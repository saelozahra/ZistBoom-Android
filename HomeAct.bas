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
	Dim RestartedBefore As Boolean = False
	Dim CanInstallAct As Boolean
End Sub

Sub Globals

	
	Dim AC As AppCompat
	Dim SpaceNavigationView1 As SpaceNavigationView
	Dim DTTC As DoubleTaptoClose
	Dim VP 			As AHViewPager
	Dim ActionBar As ACToolBarDark
	Dim Show 	As Amir_SliderShow
	Dim sv As ACSearchView
	Dim SI As ACMenuItem
	Dim X1 As XmlLayoutBuilder
	
	Dim WebViewExtras1 As WebViewExtras
	Dim EndLoading As Boolean = False
	Dim StrChat, StrProfile As AHSwipeToRefresh
	Dim ChatWV, HomeWV, ProfileWV, LoadingWV As WebView
	Dim customBrowser As JK_CustomTabsBrowser
	Dim LoginJob As HttpJob
	Dim LoginDialog As CustomDialog2
	Dim PasswordET,UserNameET As EditText
	Private Panel As Panel
	Dim wvc As DefaultWebViewClient
	
	Dim Ime1 As IME
	
End Sub

Sub Activity_Create(FirstTime As Boolean)

	Activity.LoadLayout("HomeLayout")
	
	ActionBar.Color=SaeloZahra.Color
'	ActionBar.Title=SaeloZahra.CSBTitle(Application.LabelName)
'	ActionBar.TitleTextColor=Colors.White
	ActionBar.SetLayout(0,0,100%x,SaeloZahra.MaterialActionBarHeight)
	ActionBar.LogoBitmap=LoadBitmapResize(File.DirAssets,"icon.png",SaeloZahra.MaterialActionBarHeight*1.5,SaeloZahra.MaterialActionBarHeight-14,True)
	
	LoadingWV.SetLayout(0, 0, 100%x, 100%y)
	LoadingWV.LoadHtml("<html><body style='margin:Auto;'><img src='file:///android_asset/loading_app.gif' style='width:100%;height:100%;' /></body></html>")
'	LoadingWV.LoadHtml("<body> <img style='position:absolute; top:0; left:0; width:100%; height:100%;' src='file:///android_asset/loading_app.gif' > <img style='' src='file:///android_asset/load.gif' ></body>")
	LoadingWV.BringToFront
	
	DTTC.InItIaLiZe("مجددا دکمه خروج را بزنید")
	
	
	InstallBottomMenu
	
	LoginKon
	
	If CanInstallAct Then InstallActivity
	
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















Sub Activity_KeyPress (KeyCode As Int) As Boolean
	If KeyCode = KeyCodes.KEYCODE_BACK Then
		DTTC.TapToClose
		Return True
	Else
		Return False
	End If
End Sub










Sub wvc_ReceivedError(ErrorCode As Int, Description As String, FailingUrl As String)
	Log(ErrorCode)
	Log(Description)
	Log(FailingUrl)
End Sub



#Region InstallBottomMenu

Sub ime1_HeightChanged (NewHeight As Int, OldHeight As Int)
		
	If SpaceNavigationView1.IsInitialized Then Panel.SetLayout(0,SaeloZahra.MaterialActionBarHeight,100%x,NewHeight-SpaceNavigationView1.Height-SaeloZahra.MaterialActionBarHeight+SaeloZahra.StatusBarHeight)
	If SpaceNavigationView1.IsInitialized Then SpaceNavigationView1.SetLayout(0,Panel.Top+Panel.Height-SaeloZahra.StatusBarHeight,100%x,SaeloZahra.MaterialActionBarHeight+SaeloZahra.StatusBarHeight)
	
End Sub

Sub InstallBottomMenu

	SpaceNavigationView1.SpaceBackgroundColor = SaeloZahra.ColorDark
	SpaceNavigationView1.ActiveSpaceItemColor = Colors.White
	SpaceNavigationView1.InActiveSpaceItemColor = Colors.LightGray
	SpaceNavigationView1.CentreButtonColor = SaeloZahra.ColorDark
	SpaceNavigationView1.CentreButtonColor = SaeloZahra.ColorDark
	SpaceNavigationView1.CentreButtonIcon = "baseline_cottage_white_24"
	
	Dim item As SpaceItem
	item.Initialize("پروفایل‌من","baseline_account_circle_black_24")
	SpaceNavigationView1.addSpaceItem(item)
	Dim item As SpaceItem
	item.Initialize("پیام‌ها","round_message_black_24")
	SpaceNavigationView1.addSpaceItem(item)
	
	
	SpaceNavigationView1.showIconOnly
	SaeloZahra.SetElevation(SpaceNavigationView1,1)
	AC.SetElevation(SpaceNavigationView1,1)
	
End Sub

Sub InstallActivity
	
	Dim ProfileURL As String = SaeloZahra.SiteUrl&"profile/"&File.ReadMap(SaeloZahra.Dir, "UPTemp").Get("username")&"?password="&File.ReadMap(SaeloZahra.Dir, "UPTemp").Get("password")
	ProfileAct.ProfileURL = ProfileURL
	ProfileWV.Initialize("ProfileWV")
	ProfileWV.LoadUrl(ProfileURL)
	ProfileWV.ZoomEnabled=False
'	ProfileWV.Color=Colors.Transparent
	StrProfile.Initialize("StrProfile")
	StrProfile.SetColorScheme2(Array As Int(SaeloZahra.ColorDark, SaeloZahra.ColorAccent, SaeloZahra.ColorLightTransparent))
	StrProfile.Tag=SaeloZahra.SiteUrl&"profile/"&File.ReadMap(SaeloZahra.Dir, "UPTemp").Get("username")&"?password="&File.ReadMap(SaeloZahra.Dir, "UPTemp").Get("password")
	LogColor(StrProfile.Tag, Colors.Yellow)
	StrProfile.AddView(ProfileWV)
	
	LogColor("loading HomeWV: "&SaeloZahra.SiteUrl&"home/mobile"&Main.UNQuery,Colors.Magenta)
	HomeWV.LoadUrl(SaeloZahra.SiteUrl&"home/mobile"&Main.UNQuery)
	HomeWV.ZoomEnabled=False
	
'	WebViewSettings1.setSavePassword(ProfileWV, True)
	''	WebViewSettings1.setUserAgentString(ProfileWV, "Mozilla/5.0 (Linux; Win64; x64; rv:46.0) Gecko/20100101 Firefox/68.0")
'	WebViewSettings1.setGeolocationEnabled(ProfileWV, True)
'	WebViewSettings1.setDomStorageEnabled(ProfileWV, True)
'	WebViewSettings1.setDatabaseEnabled(ProfileWV, True)
'	WebViewExtras1.addWebChromeClient(ProfileWV, "WebViewExtras1")

	Dim wcc As DefaultWebChromeClient
	wcc.Initialize("wcc")
	
	WebViewExtras1.Initialize(HomeWV)
	WebViewExtras1.SetWebChromeClient(wcc)
	

	wvc.Initialize("wvc")
	
'	HomeWV.Color=Colors.Transparent
'	StrHome.Initialize("StrChat")
'	StrHome.AddView(HomeWV)
'	StrHome.SetColorScheme2(Array As Int(SaeloZahra.ColorDark, SaeloZahra.ColorAccent, SaeloZahra.ColorLightTransparent))
	
	ChatWV.Initialize("ChatWV")
	ChatWV.ZoomEnabled=False
'	ChatWV.Color=Colors.Transparent
	ChatWV.LoadUrl(SaeloZahra.SiteUrl&$"chat/${Main.UNQuery}"$)
	StrChat.Initialize("StrChat")
	StrChat.SetColorScheme(SaeloZahra.Color,SaeloZahra.ColorAccent,SaeloZahra.ColorDark,SaeloZahra.ColorLight)
	StrChat.Tag = SaeloZahra.SiteUrl&$"chat/${Main.UNQuery}"$
	StrChat.AddView(ChatWV)
	
	Dim wccc As DefaultWebChromeClient
	wccc.Initialize("wccc")
	
	WebViewExtras1.Initialize(ChatWV)
	WebViewExtras1.SetWebChromeClient(wccc)
	
	
	Dim PC As AHPageContainer
	PC.Initialize
	PC.AddPage(StrProfile,"حساب کاربری")
'	PC.AddPage(HomeWV,Application.LabelName)
	PC.AddPage(StrChat,"پیام‌ها")
	VP.PageContainer = PC
	VP.CurrentPage = 1
	
	VP.SendToBack
	SpaceNavigationView1.BringToFront
	
	
	
	Panel.SetLayout(     0,SaeloZahra.MaterialActionBarHeight,100%x,100%y-SpaceNavigationView1.Height-SaeloZahra.MaterialActionBarHeight+SaeloZahra.StatusBarHeight)
	HomeWV.SetLayout(0, 0, 100%x, -2)
	VP.SetLayout(0, 0, 100%x, -2)
	LoadingWV.SetLayout(0, 0, 100%x, 100%y)
	
End Sub

Sub StrChat_Refresh
	ChatWV.LoadUrl(StrChat.Tag)
	LogColor("Refreshing Chat",Colors.DarkGray)
	Log(StrChat.Tag)
End Sub

Sub StrProfile_Refresh
	LogColor("Refreshing Profile",Colors.DarkGray)
	ProfileWV.LoadUrl(StrProfile.Tag)
End Sub

Sub ChatWV_PageFinished (Url As String)
	StrChat.Refreshing=False
End Sub

Sub HomeWV_PageFinished (Url As String)
	LogColor("HomeWV_PageFinished", SaeloZahra.ColorAccent)
	EndLoading=True
	LoadingWV.SetVisibleAnimated(1313, False)
	Sleep(1313)
	LoadingWV.SendToBack
	Sleep(313)
	If SpaceNavigationView1.IsInitialized Then CallSub(Me, "SpaceNavigationView1_onCentreButtonClick")
End Sub

Sub HomeWV_OverrideUrl (Url As String) As Boolean
	Log(Url)
	
	If SaeloZahra.WVRoles(Url) == Url Then
		customBrowser.CreateNewTab(Url)
	End If
	
	Return True
End Sub

'Sub ChatWV_OverrideUrl (Url As String) As Boolean
'	customBrowser.CreateNewTab(Url)
'	Log(Url)
'	Return False
'End Sub

Private Sub VP_PageChanged (Position As Int)
	
	If SpaceNavigationView1.IsInitialized Then SpaceNavigationView1.changeCurrentItem(Position)
	
	If Position == 2 Then
		If File.Exists(SaeloZahra.Dir,"UPTemp") Then
			ChatWV.LoadUrl(SaeloZahra.SiteUrl&"home/mobile"&Main.UNQuery)
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

Sub SpaceNavigationView1_onCentreButtonClick
	
	SpaceNavigationView1.showBadgeAtIndex(1, 8,Colors.Red)
	LogColor("SpaceNavi_onCentreButtonClick()", SaeloZahra.ColorDark)
	
	SpaceNavigationView1.ActiveSpaceItemColor   = Colors.LightGray
	
	VP.SendToBack
	VP.SetVisibleAnimated(313,False)
	HomeWV.BringToFront
	HomeWV.SetVisibleAnimated(313,True)
	SpaceNavigationView1.BringToFront
	
	
End Sub

Sub SpaceNavigationView1_onItemReselected(index As Int, text As String)
	
	SpaceNavigationView1.ActiveSpaceItemColor = Colors.White
	
	Log("EndLoading: "&EndLoading)
	If EndLoading Then
		Log("EventName_onItemReselected "&index&" : "& text)
		
		HomeWV.SetVisibleAnimated(313,False)
		HomeWV.SendToBack
		VP.SetVisibleAnimated(313,True)
		VP.BringToFront
		SpaceNavigationView1.BringToFront
	End If
End Sub

Sub SpaceNavigationView1_onItemClick(index As Int, text As String)
	
	SpaceNavigationView1_onItemReselected(index, text)
	SpaceNavigationView1.ActiveSpaceItemColor = Colors.White
	
	VP.CurrentPage = index
	Log($"SpaceNavi_onItemClick(${index},${text})"$)
	
End Sub


#End Region


Sub LoginKon
	
	LoginJob.Initialize("LoginJob", Me)
	LoginJob.Tag="home"
	
	If File.Exists(SaeloZahra.Dir,"UPTemp") Then
		
		LoginJob.Download(SaeloZahra.JsonUrl&"login"&Main.UNQuery)
		LogColor(SaeloZahra.JsonUrl&"login"&Main.UNQuery,Colors.Yellow)
		
	Else
		Dim PLogin As Panel
		PLogin.Initialize("PLogin")
		UserNameET.Initialize("UserNameET")
		'	UserNameET.InputType=UserNameET.INPUT_TYPE_PHONE
		UserNameET.Typeface=SaeloZahra.Font
		UserNameET.Hint="نام کاربری"
		PLogin.AddView(UserNameET,5%x,5%x,60%x,14%x)
					
		PasswordET.Initialize("PasswordET")
		PasswordET.Typeface=SaeloZahra.Font
		PasswordET.Hint="کلمه عبور"
		PasswordET.PasswordMode=True
		PLogin.AddView(PasswordET,5%x,25%x,60%x,14%x)
					
		
		LoginDialog.AddView(PLogin,72%x,45%x)
		
		Dim loginDialogResult As Int = LoginDialog.Show( SaeloZahra.CSB("ورود به حساب کاربری") , SaeloZahra.CSB("ورود") , SaeloZahra.CSB("لغو") , SaeloZahra.CSB("ثبت نام") , Null)
		If loginDialogResult == DialogResponse.POSITIVE Then
					
			Dim M1 As Map
			M1.Initialize
			M1.Put("username",UserNameET.Text)
			M1.Put("password",PasswordET.Text)
			File.WriteMap(SaeloZahra.Dir,"UPTemp",M1)
'			LoginJob.PostMultipart(SaeloZahra.JsonUrl&"login",M1,Null)
			LoginJob.Download(SaeloZahra.JsonUrl&"login?username="&UserNameET.Text&"&password="&PasswordET.Text)
			ProgressDialogShow(SaeloZahra.CSBTitle("کمی صبر کنید"))
		
		else If loginDialogResult == DialogResponse.NEGATIVE Then
'			SaeloZahra.SetAnimation("zoom_exit","zoom_enter")
'			Show.convertActivityFromTranslucent
'			StartActivity(ProfileAct) TODO
			customBrowser.CreateNewTab(SaeloZahra.SiteUrl&"signup")
		End If
		
	End If

	Log(SaeloZahra.JsonUrl&"login"&Main.UNQuery)
	
	
End Sub




Sub JobDone(job As HttpJob)
	ProgressDialogHide
	If job.Success Then
		Select job.JobName
			Case "LoginJob"
				Dim parser As JSONParser
				parser.Initialize(job.GetString)
				Dim jRoot As Map = parser.NextObject
				Main.UserInfo = jRoot
				ProfileAct.UserInfo = Main.UserInfo
				File.WriteMap(SaeloZahra.Dir,"UserInfo", jRoot)
				Main.YourID = jRoot.Get("id")
				Dim first_name As String = jRoot.Get("first_name")
				Dim last_name As String = jRoot.Get("last_name")
'				Dim username As String = jRoot.Get("username")
'				Dim email As String = jRoot.Get("email")
'				Dim bio As String = jRoot.Get("bio")
'				Dim phone_number As String = jRoot.Get("phone_number")
'				Dim city As Map = jRoot.Get("city")
'					Dim city_name As String = city.Get("city_name")
'					Dim city_id As Int = city.Get("city_id")
'					Dim city_slug As String = city.Get("city_slug")
'				Dim permission As String = jRoot.Get("permission")
				Dim Avatar As String = jRoot.Get("avatar")
'				Dim asaar As List = jRoot.Get("asaar")
'				For Each colasaar As Map In asaar
'					Dim description As String = colasaar.Get("description")
'					Dim id As Int = colasaar.Get("id")
'					Dim title As String = colasaar.Get("title")
'					Dim picture As String = colasaar.Get("picture")
'				Next
				Dim AvatarJob As HttpJob
				AvatarJob.Initialize("AvatarJob",Me)
				Log("downloading: "&SaeloZahra.SiteUrl&Avatar)
				AvatarJob.Download(SaeloZahra.SiteUrl&Avatar)
				Wait For (AvatarJob) JobDone(ja As HttpJob)
				If ja.Success Then
					Dim out As OutputStream = File.OpenOutput(SaeloZahra.Dir, "avatar.jpg", False)
					File.Copy2(ja.GetInputStream, out)
					out.Close
				End If
				ja.Release
				Log("First: "&Main.GlobalFirstTime)
				Log(job.GetString)
				ToastMessageShow(SaeloZahra.CSB(first_name&" "&last_name&" خوش آمدید."),True)
				
				RestartApp(True)
				
	
		End Select
	Else
		If job.ErrorMessage == "{""status"":""username is incorrect""}" Then
			ToastMessageShow(SaeloZahra.CSB(" نام کاربری غلطه"), True)
			File.Delete(SaeloZahra.Dir,"UPTemp")
			LoginKon
		else If job.ErrorMessage == "{""status"":""password is incorrect""}" Then
			ToastMessageShow(SaeloZahra.CSB(" کلمه‌عبور غلطه"), True)
			File.Delete(SaeloZahra.Dir,"UPTemp")
			LoginKon
		Else if job.ErrorMessage.Contains(" GET مجاز نیست.") Then
			ToastMessageShow(SaeloZahra.CSB(" متد GET مجاز نیست"), True)

		ELSE If Not(SaeloZahra.CheckConnection) Then
			Msgbox2Async("خطای اینترنت", SaeloZahra.CSB(" شبکه قطع شده "&CRLF&"و نمیتونید به سایت وصل بشید!!!"), "تلاش مجدد", "", "خروج", Null, False)
			Wait For Msgbox_Result (Result As Int)
			If Result = DialogResponse.POSITIVE Then
				RestartedBefore = False
				RestartApp(False)
			End If
		else If Not(SaeloZahra.CheckSite) Then
			Msgbox2Async("خطای اینترنت", SaeloZahra.CSB(" اینترنتتون قطع شده "&CRLF&"و نمیتونید به سایت وصل بشید!!!"), "تلاش مجدد", "", "خروج", Null, False)
			Wait For Msgbox_Result (Result As Int)
			If Result = DialogResponse.POSITIVE Then
				RestartedBefore = False
				RestartApp(False)
			End If
		Else
			ToastMessageShow(job.ErrorMessage, True)
		End If
	End If
End Sub

Sub RestartApp(WithInstall As Boolean)
	Log("RestartApp With Activity: "&WithInstall)
	If Not(RestartedBefore) Then
		RestartedBefore = True
		Activity.Finish
		StartActivity(Me)
		CanInstallAct = WithInstall
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
	SI = Menu.Add2(1, 3, "جستجو",X1.GetDrawable("baseline_search_white_24") )
	SI.SearchView = sv
	
	
	
	
	If ProfileAct.UserInfo.IsInitialized Then
		If File.Exists(SaeloZahra.Dir, "avatar.jpg") Then
			Dim Avatar As Bitmap
			Avatar = LoadBitmapResize(SaeloZahra.Dir, "avatar.jpg" ,SaeloZahra.MaterialActionBarHeight,SaeloZahra.MaterialActionBarHeight ,True)
			Try
'				Avatar = SaeloZahra.JO.RunMethod("getRoundBitmap",Array(Avatar,SaeloZahra.ColorLight, 20))
				Avatar = SaeloZahra.CreateRoundBitmap(Avatar, SaeloZahra.MaterialActionBarHeight)
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
		Menu.Add2(3,1,"ورود",		X1.GetDrawable("round_login_white_24") 				).ShowAsAction = 2
		Menu.Add2(4, 4, "ثبت‌نام", X1.GetDrawable("twotone_app_registration_white_24") ).ShowAsAction = 2
	End If
	
'	If UserInfo.IsInitialized Then Menu.Add2(2,2,"موارد ذخیره شده",X1.GetDrawable("twotone_bookmarks_white_24") ).ShowAsAction = 2
	
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
			If ProfileAct.UserInfo.IsInitialized Then
				SaeloZahra.SetAnimation("zoom_exit","zoom_enter")
				Show.convertActivityFromTranslucent
				StartActivity(ProfileAct)
				ToastMessageShow(SaeloZahra.CSB(ProfileAct.UserInfo.Get("first_name")&" "&ProfileAct.UserInfo.Get("last_name")),True)
			Else
				LoginKon
			End If
		Case 4
			SaeloZahra.SetAnimation("zoom_exit","zoom_enter")
			Show.convertActivityFromTranslucent
			StartActivity(RegisterAct)
			
	End Select
End Sub

#End Region

