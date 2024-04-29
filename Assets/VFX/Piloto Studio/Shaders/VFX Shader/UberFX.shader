
Shader "Piloto Studio/UberFX"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.BlendMode)]_SourceBlendRGB("Blend Mode", Float) = 10
		_MainTex("Main Texture", 2D) = "white" {}
		_MainTextureChannel("Main Texture Channel", Vector) = (1,1,1,0)
		_MainAlphaChannel("Main Alpha Channel", Vector) = (0,0,0,1)
		_MainTexturePanning("Main Texture Panning ", Vector) = (0.2522222,0,0,0)
		_Desaturate("Desaturate? ", Range( 0 , 1)) = 0
		[Toggle(_USESOFTALPHA_ON)] _UseSoftAlpha("Use Soft Particles?", Float) = 0
		_SoftFadeFactor("Soft Fade Factor", Range( 0.1 , 1)) = 0.1
		[Toggle(_USEALPHAOVERRIDE_ON)] _UseAlphaOverride("Use Alpha Override", Float) = 0
		_AlphaOverride("Alpha Override", 2D) = "white" {}
		_AlphaOverrideChannel("Alpha Override Channel", Vector) = (0,0,0,1)
		_AlphaOverridePanning("Alpha Override Panning", Vector) = (0,0,0,0)
		_DetailNoise("Detail Noise", 2D) = "white" {}
		_DetailNoisePanning("Detail Noise Panning", Vector) = (0.2,0,0,0)
		_DetailDistortionChannel("Detail Distortion Channel", Vector) = (0,0,0,1)
		_DistortionIntensity("Distortion Intensity", Range( 0 , 3)) = 2
		_DetailMultiplyChannel("Detail Multiply Channel", Vector) = (1,1,1,0)
		_MultiplyNoiseDesaturation("Multiply Noise Desaturation", Range( 0 , 1)) = 1
		_DetailAdditiveChannel("Detail Additive Channel", Vector) = (0,0,0,1)
		_DetailDisolveChannel("Detail Disolve Channel", Vector) = (0,0,0,1)
		[Toggle(_USERAMP_ON)] _UseRamp("Use Color Ramping?", Float) = 0
		_MiddlePointPos("Middle Point Position", Range( 0 , 1)) = 0.5
		_WhiteColor("Highs", Color) = (1,0.8950032,0,0)
		_MidColor("Middles", Color) = (1,0.4447915,0,0)
		_LastColor("Lows", Color) = (1,0,0,0)
		[Toggle(_USEUVOFFSET_ON)] _UseUVOffset("Use UV Offset", Float) = 0
		[Toggle(_FRESNEL_ON)] _Fresnel("Fresnel", Float) = 0
		_FresnelPower("Fresnel Power", Float) = 1
		_FresnelScale("Fresnel Scale", Float) = 1
		[HDR]_FresnelColor("Fresnel Color", Color) = (1,1,1,1)
		[Toggle(_DISABLEEROSION_ON)] _DisableErosion("Disable Erosion", Float) = 0
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Back
		ZWrite Off
		Blend SrcAlpha [_SourceBlendRGB]
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 5.0
		#pragma shader_feature_local _FRESNEL_ON
		#pragma shader_feature_local _USERAMP_ON
		#pragma shader_feature_local _USEUVOFFSET_ON
		#pragma shader_feature_local _DISABLEEROSION_ON
		#pragma shader_feature_local _USESOFTALPHA_ON
		#pragma shader_feature_local _USEALPHAOVERRIDE_ON
		#pragma surface surf Unlit keepalpha 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv_texcoord;
			float4 uv2_texcoord2;
			float4 screenPos;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float _SourceBlendRGB;
		uniform sampler2D _MainTex;
		uniform float2 _MainTexturePanning;
		uniform float4 _MainTex_ST;
		uniform sampler2D _DetailNoise;
		uniform float2 _DetailNoisePanning;
		uniform float4 _DetailNoise_ST;
		uniform float4 _DetailDistortionChannel;
		uniform float _DistortionIntensity;
		uniform float4 _MainTextureChannel;
		uniform float _Desaturate;
		uniform float4 _DetailMultiplyChannel;
		uniform float _MultiplyNoiseDesaturation;
		uniform float4 _DetailAdditiveChannel;
		uniform float4 _LastColor;
		uniform float4 _MidColor;
		uniform float _MiddlePointPos;
		uniform float4 _WhiteColor;
		uniform float4 _DetailDisolveChannel;
		uniform sampler2D _AlphaOverride;
		uniform float2 _AlphaOverridePanning;
		uniform float4 _AlphaOverride_ST;
		uniform float4 _AlphaOverrideChannel;
		uniform float4 _MainAlphaChannel;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _SoftFadeFactor;
		uniform float4 _FresnelColor;
		uniform float _FresnelScale;
		uniform float _FresnelPower;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 uvs_MainTex = i.uv_texcoord;
			uvs_MainTex.xy = i.uv_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 uvs_DetailNoise = i.uv_texcoord;
			uvs_DetailNoise.xy = i.uv_texcoord.xy * _DetailNoise_ST.xy + _DetailNoise_ST.zw;
			float2 panner80 = ( 1.0 * _Time.y * _DetailNoisePanning + uvs_DetailNoise.xy);
			float4 tex2DNode79 = tex2D( _DetailNoise, panner80 );
			float4 break17_g202 = tex2DNode79;
			float4 appendResult18_g202 = (float4(break17_g202.x , break17_g202.y , break17_g202.z , break17_g202.w));
			float4 clampResult19_g202 = clamp( ( appendResult18_g202 * _DetailDistortionChannel ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float4 break2_g202 = clampResult19_g202;
			float clampResult20_g202 = clamp( ( break2_g202.x + break2_g202.y + break2_g202.z + break2_g202.w ) , 0.0 , 1.0 );
			float DistortionNoise90 = clampResult20_g202;
			float temp_output_284_0 = ( DistortionNoise90 * _DistortionIntensity );
			float2 temp_cast_1 = (temp_output_284_0).xx;
			float2 appendResult400 = (float2(i.uv2_texcoord2.x , i.uv2_texcoord2.y));
			#ifdef _USEUVOFFSET_ON
				float2 staticSwitch402 = ( temp_output_284_0 + appendResult400 );
			#else
				float2 staticSwitch402 = temp_cast_1;
			#endif
			float2 UVModifiers204 = staticSwitch402;
			float2 panner22 = ( 1.0 * _Time.y * _MainTexturePanning + ( uvs_MainTex.xy + UVModifiers204 ));
			float4 tex2DNode6 = tex2D( _MainTex, panner22 );
			float4 break376 = tex2DNode6;
			float4 break379 = _MainTextureChannel;
			float4 appendResult375 = (float4(( break376.r * break379.x ) , ( break376.g * break379.y ) , ( break376.b * break379.z ) , ( break376.a * break379.w )));
			float4 MainTexInfo25 = appendResult375;
			float3 desaturateInitialColor166 = MainTexInfo25.xyz;
			float desaturateDot166 = dot( desaturateInitialColor166, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar166 = lerp( desaturateInitialColor166, desaturateDot166.xxx, _Desaturate );
			float4 break364 = ( _DetailMultiplyChannel * tex2DNode79 );
			float4 appendResult365 = (float4(break364.x , break364.y , break364.z , break364.w));
			float3 desaturateInitialColor362 = appendResult365.xyz;
			float desaturateDot362 = dot( desaturateInitialColor362, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar362 = lerp( desaturateInitialColor362, desaturateDot362.xxx, _MultiplyNoiseDesaturation );
			float3 temp_cast_5 = (1.0).xxx;
			float3 temp_cast_6 = (1.0).xxx;
			float3 ifLocalVar106 = 0;
			if( ( _DetailMultiplyChannel.x + _DetailMultiplyChannel.y + _DetailMultiplyChannel.z + _DetailMultiplyChannel.w ) <= 0.0 )
				ifLocalVar106 = temp_cast_6;
			else
				ifLocalVar106 = desaturateVar362;
			float3 MultiplyNoise92 = ifLocalVar106;
			float4 break156 = ( _DetailAdditiveChannel * tex2DNode79 );
			float4 appendResult155 = (float4(break156.x , break156.y , break156.z , break156.w));
			float3 desaturateInitialColor191 = appendResult155.xyz;
			float desaturateDot191 = dot( desaturateInitialColor191, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar191 = lerp( desaturateInitialColor191, desaturateDot191.xxx, 1.0 );
			float3 AdditiveNoise91 = desaturateVar191;
			float3 PreRamp210 = desaturateVar166;
			float temp_output_215_0 = ( 1.0 - _MiddlePointPos );
			float3 temp_cast_10 = (temp_output_215_0).xxx;
			float4 lerpResult220 = lerp( _LastColor , _MidColor , float4( (float3( 0,0,0 ) + (( PreRamp210 * temp_output_215_0 ) - float3( 0,0,0 )) * (float3( 1,1,1 ) - float3( 0,0,0 )) / (temp_cast_10 - float3( 0,0,0 ))) , 0.0 ));
			float3 temp_cast_12 = (_MiddlePointPos).xxx;
			float3 clampResult218 = clamp( ( PreRamp210 - temp_cast_12 ) , float3( 0,0,0 ) , float3( 1,1,1 ) );
			float3 temp_cast_13 = (temp_output_215_0).xxx;
			float4 lerpResult225 = lerp( _MidColor , _WhiteColor , float4( (float3( 0,0,0 ) + (clampResult218 - float3( 0,0,0 )) * (float3( 1,1,1 ) - float3( 0,0,0 )) / (temp_cast_13 - float3( 0,0,0 ))) , 0.0 ));
			float4 lerpResult226 = lerp( lerpResult220 , lerpResult225 , float4( PreRamp210 , 0.0 ));
			float4 break230 = lerpResult226;
			float4 appendResult231 = (float4(break230.r , break230.g , break230.b , PreRamp210.x));
			float4 PostRamp232 = appendResult231;
			#ifdef _USERAMP_ON
				float4 staticSwitch236 = PostRamp232;
			#else
				float4 staticSwitch236 = float4( ( ( desaturateVar166 * MultiplyNoise92 ) + AdditiveNoise91 ) , 0.0 );
			#endif
			float4 temp_output_39_0 = ( i.vertexColor * staticSwitch236 * ( i.uv_texcoord.z + 1.0 ) );
			float2 _Vector0 = float2(-0.25,1);
			float temp_output_414_0 = (_Vector0.x + (( i.uv_texcoord.w + -1.0 ) - 0.0) * (_Vector0.y - _Vector0.x) / (1.0 - 0.0));
			float4 break17_g209 = tex2DNode79;
			float4 appendResult18_g209 = (float4(break17_g209.x , break17_g209.y , break17_g209.z , break17_g209.w));
			float4 clampResult19_g209 = clamp( ( appendResult18_g209 * _DetailDisolveChannel ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			float4 break2_g209 = clampResult19_g209;
			float clampResult20_g209 = clamp( ( break2_g209.x + break2_g209.y + break2_g209.z + break2_g209.w ) , 0.0 , 1.0 );
			float DisolveNoise275 = clampResult20_g209;
			float smoothstepResult416 = smoothstep( temp_output_414_0 , ( temp_output_414_0 + 0.25 ) , DisolveNoise275);
			#ifdef _DISABLEEROSION_ON
				float staticSwitch417 = 1.0;
			#else
				float staticSwitch417 = saturate( smoothstepResult416 );
			#endif
			float4 uvs_AlphaOverride = i.uv_texcoord;
			uvs_AlphaOverride.xy = i.uv_texcoord.xy * _AlphaOverride_ST.xy + _AlphaOverride_ST.zw;
			float2 panner44 = ( 1.0 * _Time.y * _AlphaOverridePanning + uvs_AlphaOverride.xy);
			float4 break2_g205 = ( tex2D( _AlphaOverride, panner44 ) * _AlphaOverrideChannel );
			float AlphaOverride49 = saturate( ( break2_g205.x + break2_g205.y + break2_g205.z + break2_g205.w ) );
			#ifdef _USEALPHAOVERRIDE_ON
				float staticSwitch313 = AlphaOverride49;
			#else
				float staticSwitch313 = 1.0;
			#endif
			float2 panner33 = ( 1.0 * _Time.y * _MainTexturePanning + ( UVModifiers204 + uvs_MainTex.xy ));
			float4 break2_g210 = ( tex2D( _MainTex, panner33 ) * _MainAlphaChannel );
			float MainAlpha30 = saturate( ( break2_g210.x + break2_g210.y + break2_g210.z + break2_g210.w ) );
			float temp_output_55_0 = ( staticSwitch313 * MainAlpha30 );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth199 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth199 = abs( ( screenDepth199 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _SoftFadeFactor ) );
			#ifdef _USESOFTALPHA_ON
				float staticSwitch198 = ( temp_output_55_0 * saturate( distanceDepth199 ) );
			#else
				float staticSwitch198 = temp_output_55_0;
			#endif
			float temp_output_396_0 = ( ( staticSwitch417 * staticSwitch198 ) * i.vertexColor.a );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV406 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode406 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV406, _FresnelPower ) );
			float4 lerpResult410 = lerp( temp_output_39_0 , _FresnelColor , fresnelNode406);
			#ifdef _FRESNEL_ON
				float4 staticSwitch403 = ( temp_output_396_0 * lerpResult410 );
			#else
				float4 staticSwitch403 = temp_output_39_0;
			#endif
			o.Emission = ( staticSwitch403 * temp_output_396_0 ).rgb;
			o.Alpha = temp_output_396_0;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
