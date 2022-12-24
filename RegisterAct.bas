﻿B4A=true
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
	Dim cc As ContentChooser
	Dim files As List
	Dim RegOperation As Boolean = True
End Sub

Sub Globals
	Dim X1 As XmlLayoutBuilder
	Dim Config 	As Amir_SliderConfig
	Dim Show 	As Amir_SliderShow
	
	Dim snake As DSSnackbar
	Dim Ime1 As IME
	Dim CityMap, ReshteMap As Map
	
	Private ActionBar As ACToolBarDark
	Private NameET As DSFloatLabelEditText
	Private FamilyET As DSFloatLabelEditText
	Private UserNameET As DSFloatLabelEditText
	Private MailET As DSFloatLabelEditText
	Private PassET1 As DSFloatLabelEditText
	Private PassET2 As DSFloatLabelEditText
	Private CitySpinner, ReshteSpinner As ACSpinner
	Private ReshteLbl, CityLbl As Label
	Private SubmitBtn As ACButton
	
	Dim CityJob, SubmitJob, ReshteJob As HttpJob
	
	Private AvatarIV As ImageView
	Private ResumeET As DSFloatLabelEditText
	Private ScrollView1 As ScrollView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	
	Activity.LoadLayout("SVLayout")
	ScrollView1.Panel.LoadLayout("RegisterLayout")
	ScrollView1.Panel.Height = SubmitBtn.Top+133dip
	
	Ime1.Initialize("ime1")
	Ime1.AddHeightChangedEvent
	
	ActionBar.Title=SaeloZahra.CSBTitle("ثبت‌نام")
	ActionBar.Color=SaeloZahra.Color
	ActionBar.NavigationIconDrawable = X1.GetDrawable("round_arrow_back_white_24")
	
	NameET.Typeface = SaeloZahra.Font
	FamilyET.Typeface = SaeloZahra.Font
	UserNameET.Typeface = SaeloZahra.Font
	UserNameET.InputType = UserNameET.INPUT_TYPE_PHONE
	MailET.Typeface = SaeloZahra.Font
	PassET1.Typeface = SaeloZahra.Font
	PassET2.Typeface = SaeloZahra.Font
	ReshteLbl.Typeface = SaeloZahra.Font
	CityLbl.Typeface = SaeloZahra.Font
	SubmitBtn.Typeface = SaeloZahra.Font
	SubmitBtn.SetButtonColors(SaeloZahra.ColorDark, SaeloZahra.Color,Colors.LightGray)
	
	CityMap.Initialize
	ReshteMap.Initialize
	
	ReshteJob.Initialize("ReshteJob", Me)
	ReshteJob.Download(SaeloZahra.JsonUrl&"reshte")
	
	CityJob.Initialize("CityJob", Me)
	CityJob.Download(SaeloZahra.JsonUrl&"city")
	SubmitJob.Initialize("SubmitJob", Me)
	
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
	
	SaeloZahra.SetStatusBarColor(SaeloZahra.Color)
	
'	customBrowser.CreateNewTab(SaeloZahra.SiteUrl&"signup")

	cc.Initialize("cc")
	
	If Not(RegOperation) Then
		NameET.Text = Main.UserInfo.Get("first_name")
		FamilyET.Text = Main.UserInfo.Get("last_name")
		UserNameET.Text = Main.UserInfo.Get("username")
		UserNameET.Enabled=False
		MailET.Text = Main.UserInfo.Get("email")
		ResumeET.Text = Main.UserInfo.Get("bio") 'todo resume
		CitySpinner.SelectedIndex = CitySpinner.IndexOf(Main.UserInfo.Get("city_name"))
		
		ActionBar.Title= SaeloZahra.CSBTitle("‌ویرایش حساب کاربری")
		SubmitBtn.Text = SaeloZahra.CSBTitle("‌ذخیره اطلاعات")
		'todo avatar
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


Sub cc_Result (Success As Boolean, Dir As String, FileName As String)
	
	Log(Success&" | "&Dir&" | "&FileName)
	
	AvatarIV.Bitmap = LoadBitmapSample(Dir, FileName, AvatarIV.Width*1.5, AvatarIV.Height*1.5 )
	files.Initialize

	Try
		Dim fd As MultipartFileData
		fd.Initialize
		fd.KeyName="avatar"

		fd.ContentType = "image/jpeg"
		
		File.Copy(Dir, FileName, File.DirInternalCache, "image1.jpg")
		
		fd.Dir= File.DirInternalCache
		fd.FileName="image1.jpg"
'		CropImageInGallery(fd.Dir,fd.FileName)
		files.Add(fd)
		
		
	Catch
		Log(LastException.Message)
		AvatarIV.Tag=""
	End Try
	
End Sub


Sub JobDone(j As HttpJob)
	If j.Success Then
		Log(j.GetString)
		Select j.JobName
			Case "CityJob"
				Dim parser As JSONParser
				parser.Initialize(j.GetString)
				Dim jRoot As List = parser.NextArray
				For Each coljRoot As Map In jRoot
					'			Dim province_id As Int = coljRoot.Get("province_id")
					Dim name As String = coljRoot.Get("name")
					'			Dim description As String = coljRoot.Get("description")
					'			Dim id As Int = coljRoot.Get("id")
					Dim slug As String = coljRoot.Get("slug")
					CitySpinner.Add(name)
					CityMap.Put(name, slug)
				Next
			Case "ReshteJob"
				Dim parser As JSONParser
				parser.Initialize(j.GetString)
				Dim jRoot As List = parser.NextArray
				For Each coljRoot As Map In jRoot
					'			Dim province_id As Int = coljRoot.Get("province_id")
					Dim title As String = coljRoot.Get("title")
					'			Dim description As String = coljRoot.Get("description")
					'			Dim id As Int = coljRoot.Get("id")
					Dim slug As String = coljRoot.Get("slug")
					ReshteSpinner.Add(title)
					ReshteMap.Put(title, slug)
				Next
			Case "SubmitJob"
				
				If j.GetString == "{""status"":""email exist""}" Then
					
					snake.Initialize("snake", Activity,SaeloZahra.CSB("ایمیل تکراریست..."), snake.DURATION_LONG)
					snake.Show
					
					MailET.RequestFocus
					
				else If j.GetString == "{""status"":""username exist""}" Then
					
					snake.Initialize("snake", Activity,SaeloZahra.CSB("نام‌کاربری تکراریست..."), snake.DURATION_LONG)
					snake.Show
					
					UserNameET.RequestFocus
					
				else If j.GetString == "{""status"":""created""}" Then
					
					Dim M1 As Map
					M1.Initialize
					M1.Put("username",UserNameET.Text)
					M1.Put("password",PassET1.Text)
					File.WriteMap(SaeloZahra.Dir,"UPTemp",M1)
					
					snake.Initialize("snake", Activity,SaeloZahra.CSB("ثبت‌نام با موفقیت انجام شد..."), snake.DURATION_LONG)
					snake.Show
					
					Sleep(1000)
					
					Activity.Finish
					
				End If
				
		End Select
	Else
		Select j.JobName
			Case "SubmitJob"
				If j.ErrorMessage == "{""status"":""email exist""}" Then
					
					snake.Initialize("snake", Activity,SaeloZahra.CSB("ایمیل تکراریست..."), snake.DURATION_LONG)
					snake.Show
					
					MailET.RequestFocus
					
				else If j.ErrorMessage == "{""status"":""username exist""}" Then
					
					snake.Initialize("snake", Activity,SaeloZahra.CSB("نام‌کاربری تکراریست..."), snake.DURATION_LONG)
					snake.Show
					
					UserNameET.RequestFocus
					
				End If
				
		End Select
		Log(j.ErrorMessage)
		ToastMessageShow(j.ErrorMessage, True)
	End If
End Sub




Private Sub SubmitBtn_Click
	
	Dim CitySlug As String = CityMap.Get(CitySpinner.SelectedItem)
	Dim ReshteSlug As String = ReshteMap.Get(ReshteSpinner.SelectedItem)
	
	Dim M1 As Map
	M1.Initialize
	M1.Put("firstname", NameET.Text)
	M1.Put("lastname", FamilyET.Text)
	M1.Put("username", UserNameET.Text)
	M1.Put("number", UserNameET.Text)
	M1.Put("email", MailET.Text)
	M1.Put("city", CitySlug)
	M1.Put("resume", ResumeET.Text)
	M1.Put("reshte", ReshteSlug)
	M1.Put("password", PassET1.Text)
	
	File.Copy(File.DirAssets, "icon.png", File.DirInternal, "icon.png")
	
	SubmitJob.PostMultipart(SaeloZahra.JsonUrl&"account/create/", M1, files)
	
End Sub

Private Sub TelET_TextChanged (Old As String, New As String)
	
End Sub

Private Sub MailET_FocusChanged (HasFocus As Boolean)
	SubmitBtn.Enabled=True
	MailET.ErrorText=""
	If Not(HasFocus) Then
		If Not(SaeloZahra.ValidateEmail(MailET.Text)) Then
			MailET.ErrorText=SaeloZahra.CSB("قالب رایانامه صحیح نیست")
			SubmitBtn.Enabled=False
		End If
	End If
End Sub

Private Sub AvatarBtn_Click
	cc.Show("image/*", "تصویر مورد نظر خود را انتخاب کنید")
End Sub


Sub ime1_HeightChanged (NewHeight As Int, OldHeight As Int)
		
	ScrollView1.SetLayout(0,SaeloZahra.MaterialActionBarHeight,100%x,NewHeight-SaeloZahra.MaterialActionBarHeight+SaeloZahra.StatusBarHeight)
	
End Sub
