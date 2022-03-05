Shader "Unlit/oof"
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
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Transparent" 
            "Queue" = "Transparent"
        }
       
        LOD 100

        Pass
        {
            Cull off
            Zwrite off
            //ZTest LEqual
            Blend One One
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

            Interpolators vert (MeshData v)
            {
                Interpolators o;
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
               // float t = saturate(InverseLerp(_ColorStart,_ColorEnd,i.uv.x))  ;
               // t = frac(t);
                float xOffset = cos(i.uv.x * TAU * 8)*0.01;
                //float t = cos(i.uv.xy *TAU *0.1 * _Time.y ) *0.5+0.5;
                float t = cos((i.uv.y+ xOffset +_Time.y)*TAU *5)*0.5+0.5;
                float4 gradient = lerp(_ColorA,_ColorB,i.uv.y);
                t *= 1 - i.uv.y;
                float topbottomremover = (abs(i.normal.y)<0.999);
                float wave = t* topbottomremover;
                return  gradient * wave;
                // return float4(UnityObjectToWorldNormal(i.normal),1);
                //return float4(i.uv,0,1);
                //return  outColor;
                //return  float4(i.normal,1);
                
                
                
            }
            ENDCG
        }
    }
}
