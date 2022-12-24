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
	Private Panel As Panel
	Dim wvc As DefaultWebViewClient
	
	Dim Ime1 As IME
	
End Sub

Sub Activity_Create(FirstTime As Boolean)

	Activity.LoadLayout("HomeLayout")
	
	ActionBar.Color=SaeloZahra.Color
	ActionBar.SetLayout(0,0,100%x,SaeloZahra.MaterialActionBarHeight)
	ActionBar.LogoBitmap=LoadBitmapResize(File.DirAssets,"icon.png",SaeloZahra.MaterialActionBarHeight*1.5,SaeloZahra.MaterialActionBarHeight-14,True)
	
	LoadingWV.SetLayout(0, 0, 100%x, 100%y)
	LoadingWV.LoadHtml("<html><body style='margin:Auto;'><img src='file:///android_asset/loading_app.gif' style='width:100%;height:100%;' /></body></html>")
	LoadingWV.BringToFront
	
	DTTC.InItIaLiZe("مجددا دکمه خروج را بزنید")
	
	
	InstallBottomMenu
	If File.Exists(SaeloZahra.Dir, "UPTemp") Then
		InstallActivity
	Else
		InstallHome
	End If
	
	
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
	Dim ProfileURL As String = ""
	ProfileURL = SaeloZahra.SiteUrl&"profile/"&File.ReadMap(SaeloZahra.Dir, "UPTemp").Get("username")&"?password="&File.ReadMap(SaeloZahra.Dir, "UPTemp").Get("password")
	ProfileAct.ProfileURL = ProfileURL
	ProfileWV.Initialize("ProfileWV")
	ProfileWV.LoadUrl(ProfileURL)
	ProfileWV.ZoomEnabled=False
'	ProfileWV.Color=Colors.Transparent
	StrProfile.Initialize("StrProfile")
	StrProfile.SetColorScheme2(Array As Int(SaeloZahra.ColorDark, SaeloZahra.ColorAccent, SaeloZahra.ColorLightTransparent))
	StrProfile.Tag=ProfileURL
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


Sub InstallHome
	
	LogColor("loading HomeWV: "&SaeloZahra.SiteUrl&"home/mobile"&Main.UNQuery,Colors.Magenta)
	HomeWV.LoadUrl(SaeloZahra.SiteUrl&"home/mobile"&Main.UNQuery)
	HomeWV.ZoomEnabled=False
	
	Dim wcc As DefaultWebChromeClient
	wcc.Initialize("wcc")
	
	WebViewExtras1.Initialize(HomeWV)
	WebViewExtras1.SetWebChromeClient(wcc)
	

	wvc.Initialize("wvc")
	
	
	
	Panel.SetLayout(0,SaeloZahra.MaterialActionBarHeight,100%x,100%y-SaeloZahra.MaterialActionBarHeight+SaeloZahra.StatusBarHeight)
	HomeWV.SetLayout(0, 0, 100%x, -2)
	VP.Visible=False
	LoadingWV.SetLayout(0, 0, 100%x, 100%y)
	SpaceNavigationView1.Visible=False
	SpaceNavigationView1.SendToBack
	
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
	If SpaceNavigationView1.IsInitialized And File.Exists(SaeloZahra.Dir, "UPTemp") Then
		CallSub(Me, "SpaceNavigationView1_onCentreButtonClick")
	End If
End Sub

Sub HomeWV_OverrideUrl (Url As String) As Boolean
	Log(Url)
	
	If SaeloZahra.WVRoles(Url) == Url Then
		customBrowser.CreateNewTab(Url)
	End If
	
	Return True
End Sub

Sub ProfileWV_OverrideUrl (Url As String) As Boolean
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
		ChatWV.LoadUrl(SaeloZahra.SiteUrl&"home/mobile"&Main.UNQuery)
		ChatWV.Tag="home"
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
			Avatar.Initialize(File.DirAssets, "avatar.png")
			Try
				Avatar = LoadBitmapResize(SaeloZahra.Dir, "avatar.jpg" ,SaeloZahra.MaterialActionBarHeight,SaeloZahra.MaterialActionBarHeight ,True)
'				Avatar = SaeloZahra.JO.RunMethod("getRoundBitmap",Array(Avatar,SaeloZahra.ColorLight, 20))
				Avatar = SaeloZahra.CreateRoundBitmap(Avatar, SaeloZahra.MaterialActionBarHeight)
			Catch
				File.Delete(SaeloZahra.Dir, "avatar.jpg")
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
		Menu.Add2(2,2,"ورود به حساب کاربری",X1.GetDrawable("round_login_white_24") ).ShowAsAction = 2
	End If
	
	
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
			SaeloZahra.SetAnimation("zoom_exit","zoom_enter")
			Show.convertActivityFromTranslucent
			StartActivity(LoginAct)
		Case 3
			SaeloZahra.SetAnimation("zoom_exit","zoom_enter")
			Show.convertActivityFromTranslucent
				StartActivity(ProfileAct)
			ToastMessageShow(SaeloZahra.CSB(ProfileAct.UserInfo.Get("first_name")&" "&ProfileAct.UserInfo.Get("last_name")),True)
		Case 4
			SaeloZahra.SetAnimation("zoom_exit","zoom_enter")
			Show.convertActivityFromTranslucent
			StartActivity(RegisterAct)
	End Select
End Sub

#End Region

