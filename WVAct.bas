B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=10.2
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: True
#End Region

Sub Process_Globals
	Dim WVURL,WVTitle As String
End Sub

Sub Globals
	Private X1 As XmlLayoutBuilder
	Dim Config 	As Amir_SliderConfig
	Dim Show 	As Amir_SliderShow
	Private ActionBar As ACToolBarLight
	Private WV As WebView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	
	Activity.LoadLayout("WVLayout")
	WV.Color=Colors.Transparent
	
	ActionBar.Title=SaeloZahra.CSBTitle("ویرایش اطلاعات کاربری")
	ActionBar.Color=SaeloZahra.Color
	ActionBar.TitleTextColor = Colors.White
	ActionBar.NavigationIconDrawable = X1.GetDrawable("round_arrow_back_white_24")
	ActionBar.Title = SaeloZahra.CSB(WVTitle)
	
	If SaeloZahra.P.SdkVersion>23 Then
		Config.Initialize
		Config.position(Config.POSITION_LEFT)
		Config.primaryColor(SaeloZahra.ColorDark)
		Config.edge(True)
		Config.sensitivity(100)
		Config.scrimColor(Colors.ARGB(180,0,0,0))
		Show.convertActivityToTranslucent
		Show.attachActivity(Config)
	End If
	
End Sub

Sub Activity_Resume
	WV.LoadUrl(WVURL)
End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub Actionbar_NavigationItemClick
	Activity.Finish
	SaeloZahra.SetAnimation("zoom_enter","zoom_exit")
End Sub


Sub Activity_KeyPress (KeyCode As Int) As Boolean
	If KeyCode==KeyCodes.KEYCODE_BACK Then
		Actionbar_NavigationItemClick
		Return False
	Else
		Return True
	End If
End Sub

