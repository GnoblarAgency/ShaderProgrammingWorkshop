Shader "Workshop/Unlit"
{
    // These are the custom user properties coming from unity (we see them serialized in the material)
    Properties
    {
        
    }
    
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        ZWrite On
        Cull Back

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // Contains data coming from geometry into vertex program (position, uv, normal, etc from a mesh)
            struct Attributes
            {
                float4 positionOS : POSITION;
            };

            // Contains data sent to fragment shader (we populate it in the vertex shader)
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
            };

            // -- Declare User Properties --
            
            // -- The Vertex function -- operates on a single vertex
            Varyings vert (Attributes v)
            {
                Varyings o;
                
                o.positionCS = UnityObjectToClipPos(v.positionOS);
                
                return o;
            }

            // -- The Fragment function -- operates on single pixels
            fixed4 frag (Varyings i) : SV_Target
            {
                return half4(1.0, 1.0, 1.0, 1.0);
            }
            ENDCG
        }
    }
}
