B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=11.8
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: True
#End Region

Sub Process_Globals
	Dim UserInfo As Map
	Dim YourName As String
	Dim ProfileURL As String
End Sub

Sub Globals
	Dim Config 	As Amir_SliderConfig
	Dim Show 	As Amir_SliderShow
	Dim customBrowser As JK_CustomTabsBrowser
	Dim X1 As XmlLayoutBuilder
	Private ActionBar As ACToolBarDark
	Private WebView1 As WebView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	
	Activity.LoadLayout("WVLayout")

	ActionBar.Title=SaeloZahra.CSBTitle("حساب کاربری")
	ActionBar.Color=SaeloZahra.Color
	ActionBar.TitleTextColor = Colors.White
	ActionBar.NavigationIconDrawable = X1.GetDrawable("round_arrow_back_white_24")
	ActionBar.SetLayout(0,0,100%x,SaeloZahra.MaterialActionBarHeight)
	
	ActionBar.Menu.Add2(0,0 ,SaeloZahra.CSB("ویرایش اطلاعات"), X1.GetDrawable("twotone_edit_white_24"))
	ActionBar.Menu.Add2(1 ,1 ,SaeloZahra.CSB("خروج از حساب کاربری"), X1.GetDrawable("baseline_logout_white_24"))
	
	customBrowser.Initialize
	customBrowser.ToolbarColor = SaeloZahra.Color
	customBrowser.ShowTitle = True
	customBrowser.Build
	
	
	WebView1.LoadUrl(ProfileURL)
	
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
	
	SaeloZahra.SetStatusBarColor(SaeloZahra.ColorDark)
	
	
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub Actionbar_NavigationItemClick
	Activity.Finish
	SaeloZahra.SetAnimation("zoom_enter","zoom_exit")
End Sub


Sub Actionbar_MenuItemClick (Item As ACMenuItem)
	Log(Item.Id)
	Select Item.Id
		Case 0
			RegisterAct.RegOperation=False
			SaeloZahra.SetAnimation("zoom_exit","zoom_enter")
			Show.convertActivityFromTranslucent
			StartActivity(RegisterAct)
		Case 1
			File.Delete(SaeloZahra.Dir,"UPTemp")
			Dim snake As DSSnackbar
			snake.Initialize("snake", Activity,SaeloZahra.CSB("در حال خروج..."), snake.DURATION_LONG)
			snake.SetAction("ورود مجدد")
			snake.Show
	End Select
End Sub

Sub snake_Click()
	Activity.Finish
	Activity.Finish
	StartActivity(LoginAct)
End Sub

Sub snake_Dismissed(Event As Int)
	Log(Event)
	ExitApplication
	
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
	
	If SaeloZahra.WVRoles(Url) == Url Then
		customBrowser.CreateNewTab(Url)
	End If
	
	Return True
	
End Sub