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

End Sub

Sub Globals
	Dim DTTC As DoubleTaptoClose
	Dim ParallaxDesign As Hitex_ParallaxDesign
	Dim LoginJob As HttpJob
	Private UserNameFLET As DSFloatLabelEditText
	Private PasswordFLET As DSFloatLabelEditText
	Private RegBtn As Label
	Private LoginBtn As ACButton
	Private bg_wv As WebView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	
	Activity.LoadLayout("LoginAct")
	Activity.Color=SaeloZahra.Color
	
	ParallaxDesign.Initialize
	Activity.AddView(ParallaxDesign,0,-18dip,100%x,100%y+36dip)
	ParallaxDesign.setMargins(88, 10)
	ParallaxDesign.setMultipliers(1.5f, 1.5f)
	ParallaxDesign.SetImageBitmap(LoadBitmap(File.DirAssets, "login.png"))
	ParallaxDesign.SendToBack
	
	bg_wv.LoadHtml(File.ReadString(File.DirAssets, "granim.html"))
	bg_wv.SendToBack
	bg_wv.Color=Colors.Transparent
	
	Dim Csl As CSBuilder
	Csl.Initialize
'	Csl.Typeface(SaeloZahra.Font).Append("ورود ").Typeface(Typeface.FONTAWESOME).Append(Chr(0xF234))
	Csl.Typeface(SaeloZahra.Font).Append("ورود ").Typeface(Typeface.FONTAWESOME).Append(Chr(0xF090)).PopAll
	LoginBtn.Text = Csl
	
	
	If File.Exists(SaeloZahra.Dir,"UPTemp") Then
		Dim m As Map = File.ReadMap(SaeloZahra.Dir,"UPTemp")
		UserNameFLET.Text = m.Get("username")
		PasswordFLET.Text = m.Get("password")
	End If
'	Menu.Add2(3,1,"ورود",		X1.GetDrawable("round_login_white_24") 				).ShowAsAction = 2
'	Menu.Add2(4, 4, "ثبت‌نام", X1.GetDrawable("twotone_app_registration_white_24") ).ShowAsAction = 2

	DTTC.InItIaLiZe("مجددا دکمه خروج را بزنید")

End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub


Private Sub PasswordFLET_EnterPressed
	
End Sub

Private Sub RegBtn_Click
	StartActivity(RegisterAct)
End Sub

Private Sub LoginBtn_Click
	ProgressDialogShow(SaeloZahra.CSB("در حال ورود"))
	LoginKon
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
				
				Activity.Finish
				StartActivity(HomeAct)
				
	
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
			Dim snake As DSSnackbar
			snake.Initialize("snake", Activity,SaeloZahra.CSB(" شبکه قطع شده "&CRLF&"و نمیتونید به سایت وصل بشید!!!"), snake.DURATION_LONG)
			snake.Show
		else If Not(SaeloZahra.CheckSite) Then
			Dim snake As DSSnackbar
			snake.Initialize("snake", Activity,SaeloZahra.CSB(" اینترنت‌تون قطع شده "&CRLF&"و نمیتونید به سایت وصل بشید!!!"), snake.DURATION_LONG)
			snake.Show
		Else
			Dim snake As DSSnackbar
			snake.Initialize("snake", Activity,SaeloZahra.CSB("خطا در ورود"), snake.DURATION_LONG)
			snake.Show
			ToastMessageShow(job.ErrorMessage, True)
		End If
	End If
End Sub





Sub LoginKon
	
	LoginJob.Initialize("LoginJob", Me)
	LoginJob.Tag="home"
	
	If File.Exists(SaeloZahra.Dir,"UPTemp") Then
		
		LoginJob.Download(SaeloZahra.JsonUrl&"login"&Main.UNQuery)
		LogColor(SaeloZahra.JsonUrl&"login"&Main.UNQuery,Colors.Yellow)
		
	Else
	
		Dim M1 As Map
		M1.Initialize
		M1.Put("username",UserNameFLET.Text)
		M1.Put("password",PasswordFLET.Text)
		File.WriteMap(SaeloZahra.Dir,"UPTemp",M1)
'			LoginJob.PostMultipart(SaeloZahra.JsonUrl&"login",M1,Null)
		LoginJob.Download(SaeloZahra.JsonUrl&"login?username="&UserNameFLET.Text&"&password="&PasswordFLET.Text)
		ProgressDialogShow(SaeloZahra.CSBTitle("کمی صبر کنید"))
	
	End If

	Log(SaeloZahra.JsonUrl&"login"&Main.UNQuery)
	
	
End Sub



Sub Activity_KeyPress (KeyCode As Int) As Boolean
	If KeyCode = KeyCodes.KEYCODE_BACK Then
		DTTC.TapToClose
		Return True
	Else
		Return False
	End If
End Sub



