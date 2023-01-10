Shader "Unlit/SimpleUnlitShader"
{
    Properties
    {
        _Color("Color", Color) = (1.0,1.0,1.0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            // Определения функций, используемых данным шейдером
            // Функция 'vert' будет использоваться в качестве
            // вершинного шейдера.
            #pragma vertex vert
            // Функция 'frag' будет использоваться в качестве
            // фрагментного шейдера.
            #pragma fragment frag
            // make fog work
            // #pragma multi_compile_fog
            
            // Подключение некоторых удобных утилит из Unity.
            #include "UnityCG.cginc"

            float4 _Color;
            
            // Эта структура передается в вершинный шейдер для каждой вершины
            struct appdata
            {
                float4 vertex : POSITION; // Позиция вершины в мировом пространстве.
                // float2 uv : TEXCOORD0;
            };

            // Эта структура передается в фрагментный шейдер
            // для каждого фрагмента
            struct v2f
            {
                // float2 uv : TEXCOORD0;
                // UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION; // Позиция фрагмента в экранных координатах
            };

            // sampler2D _MainTex;
            // float4 _MainTex_ST;

            // Получает вершину и преобразует ее
            v2f vert (appdata v)
            {
                v2f o;

                // Преобразовать вершину из мировых координат
                // в видимые умножением на матрицу,
                // переданную движком Unity (из UnityCG.cginc)
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                // o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                // UNITY_TRANSFER_FOG(o,o.vertex);

                // Вернуть вершину для последующей передачи
                // фрагментному шейдеру
                return o;
            }

            // Интерполирует информацию о ближайших вершинах
            // и возвращает окончательный цвет
            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                // fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 col;

                // apply fog
                // UNITY_APPLY_FOG(i.fogCoord, col);

                // вернуть исходный цвет
                col = _Color;

                // Плавно изменять цвет с течением времени - от черного до _Color
                col *= abs(_SinTime[3]);

                return col;
            }
            ENDCG
        }
    }
}
