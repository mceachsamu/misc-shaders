Shader "Unlit/water_shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		col("Main Color", Color) = (0,0,0,0)
		lightDir("light direction", Vector) = (0,0,0,0)
		camDir("camera direction", Vector) = (1,1,1,1)
		camPos("camera position", Vector) = (1,1,1,1)
		Origin("origin", Vector) = (0,0,0,0)
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
        LOD 100
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
            };

            struct v2f
            {
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float4 vec : screenPos;
            };

            sampler2D _MainTex;
			float4 col;
            float4 _MainTex_ST;
			uniform float4 lightDir;
			uniform float4 camDir;
			uniform float4 camPos;
			float PI = 3.14159265359;
            v2f vert (appdata v)
            {
                v2f o;
				o.normal = v.normal;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				o.vec = ComputeScreenPos(o.vertex);
			
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

			float clampF(float x, float min, float max) {
				if (x < min) {
					return min;
				}
				else if (x > max) {
					return max;
				}
				else {
					return x;
				}
			}

			float getCuttoff(float col) {
				if (col < 0.1) {
					return 0.0;
				}
				else if (col < 0.2) {
					return 0.1;
				}
				else if (col < 0.4) {
					return 0.2;
				}
				else if (col < 0.6) {
					return 0.4;
				}
				else if (col < 0.8) {
					return 0.6;
				}
				else if(col < 1.0){
					return 0.8;
				}
				return 1.0;
			}

			float mod(float a, float b) {
				
				return a - (b * floor(a / b));
			}

            fixed4 frag (v2f i) : SV_Target
            { 
				float distanceFromCam = sqrt((camPos - i.vertex).x + (camPos - i.vertex).y + (camPos - i.vertex).z);
				float3 lightDA = camPos - i.vertex;
				float distance = sqrt(pow(lightDA.x,2) + pow(lightDA.y,2));
				float ab = sqrt((lightDA + camDir).x + (lightDA + camDir).y + (lightDA + camDir).z);
				float3 H = (lightDA + camDir)/ab;
				float cosTheta = clamp(dot(normalize(i.normal), normalize(lightDA)), 0, 1);
				float3 E = normalize(camDir);
				float3 R = reflect(normalize(-lightDA), normalize(i.normal));
				float cosAlpha = clamp(dot(E, R), 0, 1);
                // sample the texture
				//float uvx = mod(1.0, i.uv.x);
				//float uvy = mod(1.0, i.uv.y);
				col = tex2D(_MainTex, i.vec.xy/i.vec.w);
				//col = col * (cosTheta);
				float shading = 1 * cosTheta;
				//col.rgb = clampF(1.1f - cosTheta - cosAlpha * 2 + sin(i.vertex.x / 0.9 + tex2D(_MainTex, i.vec.xy / i.vec.w).x * 10), 0, 1);// +0.5f + cosAlpha * 2 + sin(i.vertex.y / 5 + tex2D(_MainTex, i.vec) * 0), 0.0, 1.0);

				col.rgb = clampF(0.6f  +cosTheta + cosAlpha * 2 +sin(i.vertex.y ), 0, 1)*clampF((0.6f + cosTheta + cosAlpha * 2 + sin(i.vertex.x + tex2D(_MainTex, i.vec)*10)), 0, 1);
				//col.r = getCuttoff(col.r);
				//col.g = getCuttoff(col.g);
				//col.b = getCuttoff(col.b);
				//col.b = col.b*1.3;
				//col.g = col.g*1.6;
				//col.r = col.r*0.3;
				col.a = 1;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
			
            ENDCG
        }

    }

	

}
