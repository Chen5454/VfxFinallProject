Shader "Hovl/Particles/Blend_LinePath"
{
	Properties
	{
		[Toggle] _Usedepth("Use depth?", Float) = 0
		_InvFade("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_MainTex("MainTex", 2D) = "white" {}
		_Noise("Noise", 2D) = "white" {}
		_Color("Color", Color) = (0.5,0.5,0.5,1)
		_Emission("Emission", Float) = 2
		_LenghtSet1ifyouuseinPS("Lenght(Set 1 if you use in PS)", Range(0 , 1)) = 0
		_PathSet0ifyouuseinPS("Path(Set 0 if you use in PS)", Range(0 , 1)) = 0
		[Toggle]_Movenoise("Move noise", Float) = 1
		_Opacity("Opacity", Range(0 , 3)) = 1
	}

		Category
		{
			SubShader
			{
				Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" "PreviewType" = "Plane" }
				Blend SrcAlpha OneMinusSrcAlpha
				ColorMask RGB
				Cull Off
				Lighting Off
				ZWrite Off
				ZTest LEqual

				Pass {
					CGPROGRAM
					#pragma vertex vert
					#pragma fragment frag
					#pragma target 2.0
					#pragma multi_compile_particles
					#pragma multi_compile_fog	
					#include "UnityCG.cginc"

					struct appdata_t
					{
						float4 vertex : POSITION;
						fixed4 color : COLOR;
						float4 texcoord : TEXCOORD0;
						UNITY_VERTEX_INPUT_INSTANCE_ID

					};

					struct v2f
					{
						float4 vertex : SV_POSITION;
						fixed4 color : COLOR;
						float4 texcoord : TEXCOORD0;
						UNITY_FOG_COORDS(1)
						#ifdef SOFTPARTICLES_ON
						float4 projPos : TEXCOORD2;
						#endif
						UNITY_VERTEX_INPUT_INSTANCE_ID
						UNITY_VERTEX_OUTPUT_STEREO

					};


					#if UNITY_VERSION >= 560
					UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
					#else
					uniform sampler2D_float _CameraDepthTexture;
					#endif

					//Don't delete this comment
					// uniform sampler2D_float _CameraDepthTexture;

					uniform sampler2D _MainTex;
					uniform float4 _MainTex_ST;
					uniform float _InvFade;
					uniform float _PathSet0ifyouuseinPS;
					uniform float _LenghtSet1ifyouuseinPS;
					uniform sampler2D _Noise;
					uniform float _Movenoise;
					uniform float4 _Noise_ST;
					uniform float4 _Color;
					uniform float _Emission;
					uniform float _Opacity;
					uniform fixed _Usedepth;

					v2f vert(appdata_t v)
					{
						v2f o;
						UNITY_SETUP_INSTANCE_ID(v);
						UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
						UNITY_TRANSFER_INSTANCE_ID(v, o);


						v.vertex.xyz += float3(0, 0, 0);
						o.vertex = UnityObjectToClipPos(v.vertex);
						#ifdef SOFTPARTICLES_ON
							o.projPos = ComputeScreenPos(o.vertex);
							COMPUTE_EYEDEPTH(o.projPos.z);
						#endif
						o.color = v.color;
						o.texcoord = v.texcoord;
						UNITY_TRANSFER_FOG(o,o.vertex);
						return o;
					}

					fixed4 frag(v2f i) : SV_Target
					{
						float lp = 1;
						#ifdef SOFTPARTICLES_ON
							float sceneZ = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
							float partZ = i.projPos.z;
							float fade = saturate((sceneZ - partZ) / _InvFade);
							lp *= lerp(1, fade, _Usedepth);
							i.color.a *= lp;
						#endif

						float4 uv069 = i.texcoord;
						uv069.xy = i.texcoord.xy * float2(1,1) + float2(0,0);
						float temp_output_98_0 = (2.5 + ((_PathSet0ifyouuseinPS + uv069.z) - 0.0) * (1.0 - 2.5) / (1.0 - 0.0));
						float temp_output_102_0 = (1.0 + ((uv069.w * _LenghtSet1ifyouuseinPS) - 0.0) * (0.0 - 1.0) / (1.0 - 0.0));
						float clampResult107 = clamp((((temp_output_98_0 * temp_output_98_0 * temp_output_98_0 * temp_output_98_0) * uv069.x) - temp_output_102_0) , 0.0 , 1.0);
						float2 appendResult109 = (float2((clampResult107 * rsqrt((1.0 + (temp_output_102_0 - 0.0) * (0.001 - 1.0) / (1.0 - 0.0)))) , uv069.y));
						float2 clampResult85 = clamp(appendResult109 , float2(0,0) , float2(1,1));
						float4 tex2DNode23 = tex2D(_MainTex, clampResult85);
						float2 uv0_Noise = i.texcoord.xy * _Noise_ST.xy + _Noise_ST.zw;
						float4 tex2DNode24 = tex2D(_Noise, lerp(uv0_Noise,(clampResult85 * uv0_Noise),_Movenoise));
						float4 appendResult110 = (float4((((tex2DNode23 * tex2DNode24 * _Color * i.color)).rgb * _Emission) , ((tex2DNode23.a * tex2DNode24.a * _Opacity) * _Color.a * i.color.a)));

						fixed4 col = appendResult110;
						UNITY_APPLY_FOG(i.fogCoord, col);
						return col;
					}
					ENDCG
				}
			}
		}
}
	