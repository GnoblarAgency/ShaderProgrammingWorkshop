Shader "Workshop/Lit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float2 uv : TEXCOORD0;
                float3 positionWS : TEXCOORD1;
                float3 normalWS : TEXCOORD2;
                float4 positionCS : SV_POSITION;
            };

            // Declare any user properties
            sampler2D _MainTex;
            float4 _MainTex_ST;

            // -- Vertex Function --
            Varyings vert (Attributes v)
            {
                Varyings o;
                
                // Populate the data we need in the fragment shader
                o.positionWS = mul(unity_ObjectToWorld, v.positionOS);
                o.normalWS = UnityObjectToWorldNormal(v.normalOS);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.positionCS = UnityObjectToClipPos(v.positionOS);
                
                return o;
            }

            // -- Fragment function --
            half4 frag (Varyings i) : SV_Target
            {
                // Get the location of the main light in the scene
                float3 lightDirWS = UnityWorldSpaceLightDir(i.positionWS);
                
                half4 color = tex2D(_MainTex, i.uv);

                // TODO Add Lighting
                
                return color;
            }
            ENDCG
        }
        
        // shadow casting support
        UsePass "Universal Render Pipeline/Lit/SHADOWCASTER"
    }
}
