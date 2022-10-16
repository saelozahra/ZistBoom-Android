B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=11.8
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: True
	#Extends: android.support.v7.app.AppCompatActivity
#End Region

Sub Process_Globals
	Dim Link As String
	Dim PageTitle As String
End Sub

Sub Globals
	
	Dim X1 As XmlLayoutBuilder
	Dim customBrowser As JK_CustomTabsBrowser
	Dim Config 	As Amir_SliderConfig
	Dim Show 	As Amir_SliderShow
	
	Private ActionBar As ACToolBarDark
	Private WebView1 As WebView

End Sub

Sub Activity_Create(FirstTime As Boolean)
	
	ProgressDialogShow(SaeloZahra.CSB("چند لحظه صبر کنید"))
	
	Activity.LoadLayout("WVLayout")

	ActionBar.Title=SaeloZahra.CSBTitle(PageTitle)
	ActionBar.Color=SaeloZahra.Color
	ActionBar.NavigationIconDrawable = X1.GetDrawable("round_arrow_back_white_24")
	
	SaeloZahra.SetStatusBarColor(SaeloZahra.Color)
	
	customBrowser.Initialize
	customBrowser.ToolbarColor = SaeloZahra.Color
	customBrowser.ShowTitle = True
	customBrowser.Build
	
	
	Log(Link)
	WebView1.LoadUrl(Link)
	
	
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

Sub WebView1_PageFinished (URL As String)
	ProgressDialogHide
End Sub

Sub WebView1_OverrideUrl (Url As String) As Boolean
	Log(Url)
	
	If Url.Contains(SaeloZahra.SiteUrl&"chat/") Then
		Link = Url&Main.UNQuery
		PageTitle = "گفتگو"
		Activity.Finish
		StartActivity(Me)
	Else If SaeloZahra.WVRoles(Url) == Url Then
		customBrowser.CreateNewTab(Url)
	End If
	
	Return True
End Sub