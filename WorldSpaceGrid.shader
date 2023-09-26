Shader "Custom/WorldSpaceGrid"
{
    Properties
    {
		_Color("Color", Color) = (0, 0, 0)
    	_ColorBig("Color Big", Color) = (0, 0, 0)
    	_BlockSize("Block Size (m)", Range(0.2, 10)) = 1.0
    	_Width("Line Width", Range(1.0, 20.0)) = 1.0
    }
    SubShader
    {
	    Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	    Lighting Off
        ZWrite Off
        AlphaTest Off
        Blend SrcAlpha OneMinusSrcAlpha 
    	
        Pass
        {
        	
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			#define MAX_SIZE_INV 0.1
            #define MAX_SIZE 10

            fixed4 _Color;
            fixed4 _ColorBig;
            float _Width;
            float _BlockSize;
            
			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			    float4 worldPos : TEXCOORD0;
			};


            v2f vert (appdata v)
            {
                v2f o;
            	o.vertex = UnityObjectToClipPos( v.vertex );
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
            	float scale = 1.0 / _BlockSize;
            	fixed xdiff = _Width * ddx(i.worldPos) * scale;
                fixed x = frac(i.worldPos.x * scale);
            	x = smoothstep(xdiff, 0.0, x) + smoothstep(1.0 - xdiff, 1.0, x);
            	fixed y = frac(i.worldPos.y * scale);
            	y = smoothstep(xdiff, 0.0, y) + smoothstep(1.0 - xdiff, 1.0, y);
            	float has = lerp(0.0, 1.0, x);
            	has = lerp(has, 1.0, y);
                fixed4 color = lerp(fixed4(0.0, 0.0, 0.0, 0.0), _Color, has);

            	fixed xdiff2 = _Width * ddx(i.worldPos * 0.2) * scale * 2.0;
            	fixed xBig = frac(i.worldPos.x * scale * 0.2);
            	xBig = smoothstep(xdiff2, 0.0, xBig) + smoothstep(1.0 - xdiff2, 1.0, xBig);
            	fixed yBig = frac(i.worldPos.y * scale * 0.2);
            	yBig = smoothstep(xdiff2, 0.0, yBig) + smoothstep(1.0 - xdiff2, 1.0, yBig);
            	has = lerp(0.0, 1.0, xBig);
            	has = lerp(has, 1.0, yBig);
                fixed4 colorBig = lerp(fixed4(0.0, 0.0, 0.0, 0.0), _ColorBig, has);
				color = lerp(color, colorBig, has);
            	
                return color;
            }
            ENDCG
        }
    }
}
