Shader "Unlit/healthbar"
{
    Properties
    {
        [noScaleOffset] _MainTex ("Texture", 2D) = "white" {}
        _Health ("Health",Range(0,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcalpha 
        

        Pass
        {
            Zwrite off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
       

            #include "UnityCG.cginc"

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float _Health;
            float InverseLerp(float a , float b , float v)
            {
                return  (v-a)/(b-a);
            }

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
      
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                // sample the texture
             //   float4 col = tex2D(_MainTex, i.uv);
                //return col;
                float tHealthColor = saturate(InverseLerp(0.2,0.8,_Health)) ;
                float3 healthbarcolor =lerp(float3(1,0,0),float3(0,1,0),tHealthColor);
                float healthbarmask = _Health >  i.uv.x;
                clip( healthbarmask - 0.1);
                float3 Bgcolor = float3(0,0,0);
                float3 outcolor = lerp(Bgcolor,healthbarcolor,healthbarmask);
                return  float4(outcolor,0);
               
                return healthbarmask;
                // return  float4(i.uv,0,0);
            }
            ENDCG
        }
    }
}
