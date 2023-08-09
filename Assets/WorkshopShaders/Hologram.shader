Shader "Workshop/Hologram"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", color) = (1,1,1,1)
        [HDR]
        _RimColor ("Rim Color", color) = (0.5, 0, 1, 1)
        _RimPower ("Rim Power", range(0.01, 5)) = 2
        _ScanlineCount ("Scanline Size", range(0.1, 200)) = 20
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        
        Zwrite Off
        Ztest LEqual
        //Blend SrcAlpha OneMinusSrcAlpha
        // Can replace above with:
         Blend One One
        // For an additive blend
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 normalOS : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 normalWS : TEXCOORD1;
                float3 viewDirWS : TEXCOORD2;
                float3 positionWS : TEXCOORD3;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            half3 _RimColor;
            half4 _Color;
            half _RimPower;
            float _ScanlineCount;

            v2f vert (appdata v)
            {
                v2f o;
                // Get all the vertex attributes we want in the fragment shader
                o.normalWS = UnityObjectToWorldNormal(v.normalOS);
                o.positionWS = mul(unity_ObjectToWorld, v.vertex);
                o.viewDirWS = _WorldSpaceCameraPos - o.positionWS;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                half4 color = tex2D(_MainTex, i.uv) * _Color;

                i.normalWS = normalize(i.normalWS);
                i.viewDirWS = normalize(i.viewDirWS);

                // Rimlighting
                half fresnel = 1 - saturate(dot(i.viewDirWS, i.normalWS));
                fresnel = pow(fresnel, _RimPower);
                color.rgb += fresnel * _RimColor;

                // Hardlines
                color.rgb *= step(frac((i.positionWS.y* 50 + _Time.y)), 0.5);
                
                // Scanlines
                half scanline = pow(frac((i.positionWS.y - _Time.y * 0.2) * _ScanlineCount), 4);

                // We could rather add a unique color here
                color.rgb += scanline * _RimColor;

                color.rgb *= color.a;
                return color;
            }
            ENDCG
        }
    }
}
