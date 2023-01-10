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
            // ����������� �������, ������������ ������ ��������
            // ������� 'vert' ����� �������������� � ��������
            // ���������� �������.
            #pragma vertex vert
            // ������� 'frag' ����� �������������� � ��������
            // ������������ �������.
            #pragma fragment frag
            // make fog work
            // #pragma multi_compile_fog
            
            // ����������� ��������� ������� ������ �� Unity.
            #include "UnityCG.cginc"

            float4 _Color;
            
            // ��� ��������� ���������� � ��������� ������ ��� ������ �������
            struct appdata
            {
                float4 vertex : POSITION; // ������� ������� � ������� ������������.
                // float2 uv : TEXCOORD0;
            };

            // ��� ��������� ���������� � ����������� ������
            // ��� ������� ���������
            struct v2f
            {
                // float2 uv : TEXCOORD0;
                // UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION; // ������� ��������� � �������� �����������
            };

            // sampler2D _MainTex;
            // float4 _MainTex_ST;

            // �������� ������� � ����������� ��
            v2f vert (appdata v)
            {
                v2f o;

                // ������������� ������� �� ������� ���������
                // � ������� ���������� �� �������,
                // ���������� ������� Unity (�� UnityCG.cginc)
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                // o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                // UNITY_TRANSFER_FOG(o,o.vertex);

                // ������� ������� ��� ����������� ��������
                // ������������ �������
                return o;
            }

            // ������������� ���������� � ��������� ��������
            // � ���������� ������������� ����
            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                // fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 col;

                // apply fog
                // UNITY_APPLY_FOG(i.fogCoord, col);

                // ������� �������� ����
                col = _Color;

                // ������ �������� ���� � �������� ������� - �� ������� �� _Color
                col *= abs(_SinTime[3]);

                return col;
            }
            ENDCG
        }
    }
}
