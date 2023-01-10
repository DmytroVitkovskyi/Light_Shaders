Shader "Custom/SimpleSurfaceShader"
{
	Properties
	{
		// ���� ������� �������
		_Color("Color", Color) = (0.5,0.5,0.5,1)
		// �������� ��� ����������� �������;
		// �� ��������� ������������ ������� ����� ��������
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		// ��������� �����������
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		// ��������� ������������� ������ ��������� �����������
		_Metallic("Metallic", Range(0,1)) = 0.0

		// ���� �����, ��������� �����
		_RimColor("Rim Color", Color) = (1.0,1.0,1.0,0.0)

		// ������� �������, ������������ ����������
		_RimPower("Rim Power", Range(0.5,8.0)) = 2.0
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		// ��������� �������� �� ����������� ������ ���������
		// � ������������ ���� �� ���������� ����� ���� �����
	#pragma surface surf Standard fullforwardshadows

	// ������������ ������ �������� ������ 3.0, �����
	// �������� ����� ������������ ���������
	#pragma target 3.0

	// ��������� ���������� �������� "�����������" - ���� � �� ��
	// �������� ��������� ��� ������� �������
	// ��������, ������������ ������� (���������� ����)
	sampler2D _MainTex;

	// ��������� 'Input' �������� ����������, ������� ��������
	// ���������� �������� ��� ������� �������
	struct Input
	{
		// ���������� � �������� ��� ������� �������
		float2 uv_MainTex;

		// ����������� ����������� ������ ��� ������ �������
		float3 viewDir;
	};

	// �������� ��������� � �������������
	half _Glossiness;
	half _Metallic;

	// ���� �����, ��������� �����
	float4 _RimColor;

	// ������� �������, ������������ ����������, - ��� �����
	// � ����, ��� ������ ������
	float _RimPower;

	// ���� ������� ����������� �����
	fixed4 _Color;

	// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
	// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
	// #pragma instancing_options assumeuniformscaling
	UNITY_INSTANCING_BUFFER_START(Props)
		// put more per-instance properties here
	UNITY_INSTANCING_BUFFER_END(Props)

		// ��� ������������ ������� ��������� ��������
		// ������ �����������
		void surf(Input IN, inout SurfaceOutputStandard o)
		{
		// ���������� ������ � IN � ����������,
		// ����������� ����, ��������� ��������
		// � ��������� �� � 'o'
		// 
		// ������� ����������� �� �������� � ������������
		// ������ �������
		fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
		o.Albedo = c.rgb;
		// ������������� � ��������� �����������
		// �� ������� ����������
		o.Metallic = _Metallic;
		o.Smoothness = _Glossiness;
		// �������� �����-������ �����������
		// �� ��������, ������������ ��� ����������� �������
		o.Alpha = c.a;

		// ��������� ������������ �������
		// ��������� ������� ������������ ������� �������
		// ���������� ����� �����
		half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));

		// ������������ ��� ������� ��� ���������� ����� �������
		// � ������������ �� ��� ����������� ����� ����������� �����
		o.Emission = _RimColor.rgb * pow(rim, _RimPower);
	}
	ENDCG
	}
		// ���� ���������, ����������� ���� ������, �� ������������
		// ������ �������� 3.0, ������������ ����������
		// ������ "Diffuse", ������� �������� �� ��� �����������,
		// �� �������������� ��������
		FallBack "Diffuse"
}
