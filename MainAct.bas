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
	
End Sub

Sub Globals

	Dim DTTC As DoubleTaptoClose
	Dim VP 			As AHViewPager
	Dim ActionBar As ACToolBarLight
	Dim Show 	As Amir_SliderShow
	Dim sv As ACSearchView
	Dim SI As ACMenuItem
	Dim X1 As XmlLayoutBuilder
	
	Dim StrChat, StrHome, StrProfile As AHSwipeToRefresh
	Dim ChatWV, HomeWV, ProfileWV As WebView
	Dim Ime1 As IME
	Dim customBrowser As JK_CustomTabsBrowser
	Dim LoginJob As HttpJob
	Dim LoginDialog As CustomDialog2
	Dim PasswordET,UserNameET As EditText
	
End Sub

Sub Activity_Create(FirstTime As Boolean)

	Activity.LoadLayout("VPLayout")
	
	DTTC.InItIaLiZe("مجددا دکمه خروج را بزنید")
	
	
	ActionBar.PopupTheme=ActionBar.THEME_LIGHT
	ActionBar.Color=SaeloZahra.Color
'	ActionBar.Title=SaeloZahra.CSBTitle(Application.LabelName)
'	ActionBar.TitleTextColor=Colors.White
	ActionBar.SetLayout(0,0,100%x,SaeloZahra.MaterialActionBarHeight)
	ActionBar.LogoBitmap=LoadBitmapResize(File.DirAssets,"icon.png",SaeloZahra.MaterialActionBarHeight-14,SaeloZahra.MaterialActionBarHeight-14,True)
	
	InstallBottomMenu
	
	Sleep(0)
	
	
	Ime1.Initialize("ime1")
	Ime1.AddHeightChangedEvent
	
	SaeloZahra.SetStatusBarColor(SaeloZahra.Color)
	
	
	customBrowser.Initialize
	customBrowser.ToolbarColor = SaeloZahra.Color
	customBrowser.ShowTitle = True
	customBrowser.Build
	
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

#Region InstallBottomMenu

Sub ime1_HeightChanged (NewHeight As Int, OldHeight As Int)
		
	If Not(SaeloZahra.NewLayout) Then
		If BottomBar.IsInitialized Then VP.SetLayout(0,SaeloZahra.MaterialActionBarHeight,100%x,NewHeight-BottomBar.Height-SaeloZahra.MaterialActionBarHeight)
		If BottomBar.IsInitialized Then BottomBar.SetLayout(0,VP.Top+VP.Height,100%x,SaeloZahra.MaterialActionBarHeight+SaeloZahra.StatusBarHeight)
	End If
	
End Sub

Sub InstallBottomMenu
	
	Dim Items As List
	Items.Initialize
	Items.Add(BottomBar.CreateItem("پروفایل‌من"	,X1.GetDrawable("baseline_account_circle_black_24")))
	Items.Add(BottomBar.CreateItem("زیست بوم" 	,X1.GetDrawable("baseline_other_houses_black_24")))
	Items.Add(BottomBar.CreateItem("پیام‌ها"		,X1.GetDrawable("round_message_black_24")))
	
	Dim Ui As AX_SmoothBottomBarUI
	Ui.Initialize
	Ui.BarBackgroundColor = SaeloZahra.Color
	Ui.ItemTextColor = SaeloZahra.ColorDark
	Ui.ItemIconSize = 24dip
	Ui.BarIndicatorColor = 0x3FFFFFFF
	Ui.BarIndicatorRadius = 12dip
'	Ui.BarSideMargins = 0dip
	Ui.BarSideMargins = 14dip
	Ui.ItemPadding = 8dip ' har chi Kamtar beshe koochikTar Mishe
	Ui.ItemIconTint = 0xA0333333
	Ui.ItemIconTintActive = SaeloZahra.ColorDark
'	Ui.ItemTextSize = 28
	Ui.ItemTypeface=SaeloZahra.font
	BottomBar.Initialize("BottomBar",Ui,Items)
	SaeloZahra.SetElevation(BottomBar,8)
	Activity.AddView(BottomBar,0,100%y-SaeloZahra.MaterialActionBarHeight-SaeloZahra.StatusBarHeight,100%x,SaeloZahra.MaterialActionBarHeight+SaeloZahra.StatusBarHeight)
	
	BottomBar.ActiveItem = 1
	BottomBar.BringToFront
	
	
	VP.SetLayout(0,SaeloZahra.MaterialActionBarHeight,100%x,100%y-BottomBar.Height-SaeloZahra.MaterialActionBarHeight-SaeloZahra.StatusBarHeight+SaeloZahra.StatusBarHeight)
	
	
	
	ProfileWV.Initialize("ProfileWV")
	If File.Exists(SaeloZahra.Dir, "username") Then
		ProfileWV.LoadUrl(SaeloZahra.SiteUrl&"chat?username="&File.ReadString(SaeloZahra.Dir, "username")&"&password="&File.ReadString(SaeloZahra.Dir, "password"))
	End If
	ProfileWV.ZoomEnabled=False
	ProfileWV.Color=Colors.Transparent
	StrProfile.Initialize("StrProfile")
	StrProfile.SetColorScheme(SaeloZahra.Color,Colors.Yellow,SaeloZahra.ColorDark,SaeloZahra.ColorLight)
	StrProfile.AddView(ProfileWV)
	
	
	
	HomeWV.Initialize("HomeWV")
	Dim UNQuery As String
	If File.Exists(SaeloZahra.Dir, "username") Then
		UNQuery = "?username="&File.ReadString(SaeloZahra.Dir, "username")&"&password="&File.ReadString(SaeloZahra.Dir, "password")
	End If
	HomeWV.LoadUrl(SaeloZahra.SiteUrl&"home/mobile"&UNQuery)
	HomeWV.ZoomEnabled=False
	HomeWV.Color=Colors.Transparent
	StrHome.Initialize("StrChat")
	StrHome.SetColorScheme(SaeloZahra.Color,Colors.Yellow,SaeloZahra.ColorDark,SaeloZahra.ColorLight)
	StrHome.AddView(HomeWV)
	
	
	ChatWV.Initialize("ChatWV")
	If File.Exists(SaeloZahra.Dir, "username") Then
		ChatWV.LoadUrl(SaeloZahra.SiteUrl&"chat?username="&File.ReadString(SaeloZahra.Dir, "username")&"&password="&File.ReadString(SaeloZahra.Dir, "password"))
	End If
	ChatWV.ZoomEnabled=False
	ChatWV.Color=Colors.Transparent
	StrChat.Initialize("StrChat")
	StrChat.SetColorScheme(SaeloZahra.Color,Colors.Yellow,SaeloZahra.ColorDark,SaeloZahra.ColorLight)
	StrChat.AddView(ChatWV)
	
	Dim PC As AHPageContainer
	PC.Initialize
	PC.AddPage(StrProfile,"حساب کاربری")
	PC.AddPage(HomeWV,Application.LabelName)
	PC.AddPage(StrChat,"پیام‌ها")
	VP.PageContainer = PC
	VP.CurrentPage = 1
	BottomBar.ActiveItem = 1
	
	BottomBar.BringToFront
	
	
	
	
	
End Sub

'Sub THideProgress_Tick
'	IHideProgress=IHideProgress+1
'	If IHideProgress = 2 Then
'		ProgressDialogHide
'	End If
'End Sub


Private Sub VP_PageChanged (Position As Int)
	BottomBar.ActiveItem = Position
	If Position == 2 Then
		If File.Exists(SaeloZahra.Dir, "username") Then
			ChatWV.LoadUrl(SaeloZahra.SiteUrl&"home/mobile?username="&File.ReadString(SaeloZahra.Dir, "username")&"&password="&File.ReadString(SaeloZahra.Dir, "password"))
			ChatWV.Tag="home"
		Else
			LoginKon
		End If
'		sv.QueryHint=SaeloZahra.CSB("جستجو در بازارچه")
	Else If Position == 1 Then
'		sv.QueryHint=SaeloZahra.CSB("جستجو در سایت")
	Else If Position == 0 Then
'		sv.QueryHint=SaeloZahra.CSB("جستجو در رسانه ها")
	End If
	
End Sub

Private Sub BottomBar_onItemSelected (Position As Int)
	Log("onItemSelected : "&Position)
	VP.CurrentPage = Position
End Sub

#End Region


Sub LoginKon
	
	SaeloZahra.NewLayout=False
	
	Dim PLogin As Panel
	PLogin.Initialize("PLogin")
	UserNameET.Initialize("UserNameET")
	UserNameET.InputType=UserNameET.INPUT_TYPE_PHONE
	UserNameET.Typeface=SaeloZahra.Font
	UserNameET.Hint="شماره تماس"
	PLogin.AddView(UserNameET,5%x,5%x,60%x,14%x)
				
	PasswordET.Initialize("PasswordET")
	PasswordET.Typeface=SaeloZahra.Font
	PasswordET.Hint="کلمه عبور"
	PasswordET.PasswordMode=True
	PLogin.AddView(PasswordET,5%x,25%x,60%x,14%x)
				
	If File.Exists(SaeloZahra.Dir,"username") And File.Exists(SaeloZahra.Dir,"password") Then
		UserNameET.Text= File.ReadString(SaeloZahra.Dir,"username")
		PasswordET.Text= File.ReadString(SaeloZahra.Dir,"password")
	End If

	LoginDialog.AddView(PLogin,72%x,45%x)
	Dim loginDialogResult As Int = LoginDialog.Show( SaeloZahra.CSB("ورود به حساب کاربری") , SaeloZahra.CSB("ورود") , SaeloZahra.CSB("لغو") , SaeloZahra.CSB("ثبت نام") , Null)
	If loginDialogResult == DialogResponse.POSITIVE Then
					
		LoginJob.Initialize("LoginJob",Starter)
		LoginJob.Tag="home"
		Dim M1 As Map
		M1.Initialize
		M1.Put("username",UserNameET.Text)
		M1.Put("password",PasswordET.Text)
		File.WriteMap(SaeloZahra.Dir,"UPTemp",M1)
		LogColor(SaeloZahra.JsonUrl&"members/login?username="&UserNameET.Text&"&password="&PasswordET.Text,SaeloZahra.ColorDark)
		LoginJob.PostMultipart(SaeloZahra.JsonUrl&"members/login",M1,Null)
		
		ProgressDialogShow(SaeloZahra.CSBTitle("کمی صبر کنید"))
					
	else If loginDialogResult == DialogResponse.NEGATIVE Then
		SaeloZahra.SetAnimation("zoom_exit","zoom_enter")
		Show.convertActivityFromTranslucent
'		StartActivity(LoginAct) TODO
	End If
End Sub




#Region MenuSearch

'Inline Java code to initialize the Menu
#If Java
	public boolean _onCreateOptionsMenu(android.view.Menu menu) {
		if (processBA.subExists("activity_createmenu")) {
			processBA.raiseEvent2(null, true, "activity_createmenu", false, new de.amberhome.objects.appcompat.ACMenuWrapper(menu));
			return true;
		}
		else
			return false;
	}
#End If

Sub Activity_CreateMenu(Menu As ACMenu)
	
	
	Log("Create Menu")
	
	sv.Initialize2("search", sv.THEME_LIGHT)
	sv.IconifiedByDefault = True

	Menu.Clear
	ActionBar.InitMenuListener
	sv.QueryHint=SaeloZahra.csb("جستجو")
	SI = Menu.Add2(1, 3, "جستجو",X1.GetDrawable("baseline_search_black_24") )
	SI.SearchView = sv
	
	
'	If LoginAct.UserInfo.IsInitialized Then Menu.Add2(2,2,"موارد ذخیره شده",X1.GetDrawable("twotone_bookmarks_white_24") ).ShowAsAction = 2
	
	
	If ProfileAct.UserInfo.IsInitialized Then
		If File.Exists(SaeloZahra.Dir, "avatar.jpg") Then
			Dim Avatar As Bitmap
			Avatar = LoadBitmapResize(SaeloZahra.Dir, "avatar.jpg" ,SaeloZahra.MaterialActionBarHeight,SaeloZahra.MaterialActionBarHeight ,True)
			Try
				Avatar = SaeloZahra.JO.RunMethod("getRoundBitmap",Array(Avatar,SaeloZahra.ColorLight, 20))
			Catch
				Log(LastException)
			End Try
			Menu.Add(3,1,"حساب کاربری",	Avatar).ShowAsAction = 2
		Else
			Menu.Add2(3,1,"حساب کاربری",	X1.GetDrawable("baseline_account_circle_black_24") 	).ShowAsAction = 2
		End If
		
'		Menu.Add2(3,0,LoginAct.YourName, Null ).ShowAsAction = 2
		
		Dim LblYourName As Label
		LblYourName.Initialize("3")
		LblYourName.TextColor=SaeloZahra.ColorLight
		LblYourName.Text=SaeloZahra.CSB(ProfileAct.YourName)
		LblYourName.Gravity=Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)
		ActionBar.AddView(LblYourName,-2,SaeloZahra.MaterialActionBarHeight,Gravity.CENTER)
		
	Else
		Menu.Add2(3,1,"ورود",		X1.GetDrawable("round_login_black_24") 				).ShowAsAction = 2
	End If
	
	
'	Menu.Add2(3,3,"تارنمای "&application.labelname,	x1.GetDrawable("ic_gps_fixed_white_24dp") )
'	Menu.Add2(5,5,"شاخه ها", 	X1.GetDrawable("ic_playlist_play_white_24dp") ).ShowAsAction = 2
	
	
End Sub



Sub Search_QuerySubmitted (Query As String)
	
	SaeloZahra.P.HideKeyboard(Activity)
	Sleep(110)
	sv.Iconfied = True
	SI.ItemCollapsed = True
   
	Log("Search for '" & Query & "'")
	
	Dim KeyWord As String = Query.Trim
	If KeyWord = "" Then
		ProgressDialogHide
		Return
	End If
'	KeyWord = KeyWord.Replace(" ", "+")

'	Dim SU As StringUtils
'	KeyWord = SU.EncodeUrl(Query,"UTF8")
	
	SaeloZahra.SetAnimation("zoom_exit","zoom_enter")
	Show.convertActivityFromTranslucent
	SearchAct.KeyWord = KeyWord
	StartActivity(SearchAct)
	
End Sub




Sub Actionbar_MenuItemClick (Item As ACMenuItem)
	Log(Item.Id)
	Select Item.Id
		Case 0
		Case 1
		Case 2
		Case 3
'			If LoginAct.UserInfo.IsInitialized Then
'				SaeloZahra.SetAnimation("zoom_exit","zoom_enter")
'				Show.convertActivityFromTranslucent
'				StartActivity(EditMemberInfoAct)
'			Else
'				LoginKon
'			End If
	End Select
End Sub

#End Region

