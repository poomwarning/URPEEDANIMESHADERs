Shader "Unlit/vertexoffset"
{
    Properties
    {
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (1,1,1,1)
        _Bigoof ("",2D) = "white" {}
        _Scale ("UV Scale",Float) = 1 
        _Offset ("UV Offset" , Float) = 0
        _ColorStart ("Color Start",Range(0,1)) = 0
        _ColorEnd ("Color End",Range(0,1)) = 1    
        _WaveAmp ("Wave Amplitude" , Range(0,10)) = 0.1
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Opaque" 
          
        }
       
        LOD 100

        Pass
        {
         
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;
            float _Offset ;
            float _Scale;
            float _WaveAmp;
            #include "HLSLSupport.cginc"
            #include "UnityCG.cginc"
            #define TAU 6.28318530718

            struct MeshData
            {
                float4 vertex : POSITION;
                float3 normals : NORMAL;
                float4 tangent : TANGENT;
                float2 uv : TEXCOORD0;
//                float2 uv1 : TEXCOORD1;

            };

            struct Interpolators
            {
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float Getwave(float2 uv )
            {
                 float2 uvscentered = uv *2-1 ;
                 float radialDistance = length(uvscentered);
                float wave = cos((radialDistance - _Time.y *0.1 )* TAU *2)*0.25+0.25;
                wave *= 1-radialDistance;
                return  wave;
            }

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                float wave = cos ((v.uv.y - _Time.y *0.1 )* TAU *2)*0.25+0.25;
                float wave2 = cos ((v.uv.x - _Time.y *0.1 )* TAU *2)*0.25+0.25;
                float wave3 = Getwave(v.uv);
                v.vertex.y = wave3 *_WaveAmp;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal =  UnityObjectToWorldNormal(v.normals );
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv = v.uv; //(v.uv+ _Offset) * _Scale;
            //    UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }
            float InverseLerp(float a ,float b,float v)
            {
                return  (v-a)/(b-a);
            }
            fixed4 frag (Interpolators i) : SV_Target
            {
                //float wave = cos((i.uv.y - _Time.y *0.1 )* TAU *2)*0.25+0.25;
                //float4 gradient = lerp(_ColorA,_ColorB,i.uv.y);
                //wave *=  i.uv.y;
           //  return float4 (i.uv,0,1);
                //return  wave;
               return Getwave(i.uv);
            }
            ENDCG
        }
    }
}
