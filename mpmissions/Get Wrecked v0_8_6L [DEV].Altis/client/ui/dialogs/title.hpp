#define GW_TitleScreen_ID 95000
#define GW_TitleScreen_Title_ID 95001
#define GW_TitleScreen_Button_ID 95002

#define GW_BUTTON_WIDTH 0.2
#define GW_BUTTON_HEIGHT 0.035

#define GW_BUTTON_GAP_Y 0.005
#define GW_BUTTON_GAP_X 0.0025
#define GW_BUTTON_BACKGROUND {0,0,0,0.7}

#define TIMER_X (0.5 - (((GW_BUTTON_WIDTH * 1) + 0.03) /2))
#define TIMER_Y (0.5 - (((GW_BUTTON_HEIGHT * 3) + (GW_BUTTON_GAP_Y * 2) + 0.05) / 2))

#define CT_LISTBOX 5
#define CT_STRUCTURED_TEXT  13
#define CT_EDIT 2

class GW_StructuredTextBox_Title : GW_StructuredTextBox
{
	linespacing = 1;
};

class GW_TitleScreen
{
	idd = GW_TitleScreen_ID;
	name = "GW_TitleScreen";
	movingEnabled = false;
	enableSimulation = true;	
	onLoad = "uiNamespace setVariable ['GW_TitleScreen', _this select 0]; "; 

	class controlsBackground
	{

	
		class MarginBottom : GW_Block
		{
			idc = 95003;
			colorBackground[] = {0,0,0,0.85};
			x = -1;
			y = (MARGIN_BOTTOM + (GW_BUTTON_HEIGHT * 2)) * safezoneH + safezoneY; 
			w = 3;
			h = 0.25 * safezoneH;
		};	

		class MarginTop : GW_Block
		{
			idc = 95004;
			colorBackground[] = {0,0,0,0.85};
			x = -1;
			y = 0 * safezoneH + safezoneY; 
			w = 3;
			h = MARGIN_TOP + (GW_BUTTON_HEIGHT) * safezoneH;
		};	

	};

	class controls
	{
		class ButtonBlank : GW_RscButtonMenu
		{
			idc = -1;
			text = "";
			onButtonClick = "";
			colorBackgroundFocused[] = {0,0,0,0};
			colorBackground[] = {0,0,0,0};
			colorBackground2[] = {0,0,0,0};
			x = (0) * safezoneW + safezoneX;
			y = (0) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safezoneW;
			h = GW_BUTTON_HEIGHT * safezoneH;

		};

		class TitleScreenTitle : GW_StructuredTextBox_Title
		{
			idc = GW_TitleScreen_Title_ID;
			text = "";
			
			x = (0.1) * safezoneW + safezoneX;
			y = (0.4) * safezoneH + safezoneY;
			w = 0.8  * safezoneW;
			h = 0.2  * safezoneH;

			colorBackground[] = {0,0,0,0};

		};

		class TitleScreenButton : GW_RscButtonMenu

		{
			idc = GW_TitleScreen_Button_ID;
			text = "ABORT";
			onButtonClick = "[] call functionOnComplete;";

			x = (0.4) * safezoneW + safezoneX;
			y = (MARGIN_BOTTOM) * safezoneH + safezoneY;
			w = (GW_BUTTON_WIDTH) * safeZoneW;
			h = GW_BUTTON_HEIGHT  * safeZoneH;

		
			class TextPos
			{
				left = 0;
				top = 0.0135;
				right = 0;
				bottom = 0;
			};
		};
	};
};