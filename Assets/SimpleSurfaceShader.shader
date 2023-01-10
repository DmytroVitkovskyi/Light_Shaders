Shader "Custom/SimpleSurfaceShader"
{
	Properties
	{
		// Цвет оттенка объекта
		_Color("Color", Color) = (0.5,0.5,0.5,1)
		// Текстура для обертывания объекта;
		// по умолчанию используется плоская белая текстура
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		// Гладкость поверхности
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		// Насколько металлической должна выглядеть поверхность
		_Metallic("Metallic", Range(0,1)) = 0.0

		// Цвет света, падающего сзади
		_RimColor("Rim Color", Color) = (1.0,1.0,1.0,0.0)

		// Толщина контура, создаваемого подсветкой
		_RimPower("Rim Power", Range(0.5,8.0)) = 2.0
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		// Физически основана на стандартной модели освещения
		// и поддерживает тени от источников света всех типов
	#pragma surface surf Standard fullforwardshadows

	// Использовать модель шейдеров версии 3.0, чтобы
	// получить более реалистичное освещение
	#pragma target 3.0

	// Следующие переменные являются "униформными" - одно и то же
	// значение действует для каждого пиксела
	// Текстура, определяющая альбедо (отраженный свет)
	sampler2D _MainTex;

	// Структура 'Input' содержит переменные, которые получают
	// уникальные значения для каждого пиксела
	struct Input
	{
		// Координаты в текстуре для данного пиксела
		float2 uv_MainTex;

		// Направление визирования камеры для данной вершины
		float3 viewDir;
	};

	// Свойства гладкости и металличности
	half _Glossiness;
	half _Metallic;

	// Цвет света, падающего сзади
	float4 _RimColor;

	// Толщина контура, создаваемого подсветкой, - чем ближе
	// к нулю, тем тоньше контур
	float _RimPower;

	// Цвет оттенка отраженного света
	fixed4 _Color;

	// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
	// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
	// #pragma instancing_options assumeuniformscaling
	UNITY_INSTANCING_BUFFER_START(Props)
		// put more per-instance properties here
	UNITY_INSTANCING_BUFFER_END(Props)

		// Эта единственная функция вычисляет свойства
		// данной поверхности
		void surf(Input IN, inout SurfaceOutputStandard o)
		{
		// Использует данные в IN и переменные,
		// объявленные выше, вычисляет значения
		// и сохраняет их в 'o'
		// 
		// Альбедо извлекается из текстуры и окрашивается
		// цветом оттенка
		fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
		o.Albedo = c.rgb;
		// Металличность и гладкость извлекаются
		// из текущих переменных
		o.Metallic = _Metallic;
		o.Smoothness = _Glossiness;
		// Значение альфа-канала извлекается
		// из текстуры, используемой для определения альбедо
		o.Alpha = c.a;

		// Доработка стандартного шейдера
		// Вычислить яркость освещенности данного пиксела
		// источником света сзади
		half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));

		// Использовать эту яркость для вычисления цвета контура
		// и использовать ее для определения цвета отраженного света
		o.Emission = _RimColor.rgb * pow(rim, _RimPower);
	}
	ENDCG
	}
		// Если компьютер, выполняющий этот шейдер, не поддерживает
		// модель шейдеров 3.0, использовать встроенный
		// шейдер "Diffuse", который выглядит не так реалистично,
		// но гарантированно работает
		FallBack "Diffuse"
}
