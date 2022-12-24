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
	Dim ReshteMap As Map
	
	Private ActionBar As ACToolBarDark
	Private ScrollView1 As ScrollView
	Private ReshteSpinner As ACSpinner
	Private ReshteLbl As Label
	Private SubmitBtn, PicBtn As ACButton
	
	Dim SubmitJob, ReshteJob As HttpJob
	
	Private TitleET, TarikhET, DescET, TeamET As DSFloatLabelEditText
	Private PicIV As ImageView
	Private DateFab As DSFloatingActionButton
End Sub

Sub Activity_Create(FirstTime As Boolean)
	
	Activity.LoadLayout("SVLayout")
	ScrollView1.Panel.LoadLayout("ArtistEffectLayout")
	ScrollView1.Panel.Height = SubmitBtn.Top+133dip
	
	Ime1.Initialize("ime1")
	Ime1.AddHeightChangedEvent
	
	ActionBar.Title=SaeloZahra.CSBTitle("ثبت‌ اثر هنری")
	ActionBar.Color=SaeloZahra.Color
	ActionBar.NavigationIconDrawable = X1.GetDrawable("round_arrow_back_white_24")
	
	TitleET.Typeface = SaeloZahra.Font
	TarikhET.Typeface = SaeloZahra.Font
	DescET.Typeface = SaeloZahra.Font
	TeamET.Typeface = SaeloZahra.Font
	PicBtn.Typeface = SaeloZahra.Font
	ReshteLbl.Typeface = SaeloZahra.Font
	SubmitBtn.Typeface = SaeloZahra.Font
	SubmitBtn.SetButtonColors(SaeloZahra.ColorDark, SaeloZahra.Color,Colors.LightGray)
	DateFab.SetIcon(X1.GetDrawable("baseline_more_time_white_24"))
	DateFab.RippleColor=SaeloZahra.Color
	DateFab.Color=SaeloZahra.ColorLight
	DateFab.Size = DateFab.SIZE_MINI
	
	ReshteMap.Initialize
	
	ReshteJob.Initialize("ReshteJob", Me)
	ReshteJob.Download(SaeloZahra.JsonUrl&"reshte")
	
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
	
	cc.Initialize("cc")
	
	If Not(RegOperation) Then
'		NameET.Text = Main.UserInfo.Get("first_name")
'		FamilyET.Text = Main.UserInfo.Get("last_name")
'		UserNameET.Text = Main.UserInfo.Get("username")
'		UserNameET.Enabled=False
'		MailET.Text = Main.UserInfo.Get("email")
'		ResumeET.Text = Main.UserInfo.Get("bio") 'todo resume
'		CitySpinner.SelectedIndex = CitySpinner.IndexOf(Main.UserInfo.Get("city_name"))
'		
'		ActionBar.Title= SaeloZahra.CSBTitle("‌ویرایش حساب کاربری")
'		SubmitBtn.Text = SaeloZahra.CSBTitle("‌ذخیره اطلاعات")
'		'todo avatar
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
	
	PicIV.Bitmap = LoadBitmapSample(Dir, FileName, PicIV.Width*1.5, PicIV.Height*1.5 )
	files.Initialize

	Try
		Dim fd As MultipartFileData
		fd.Initialize
		fd.KeyName="picture"

		fd.ContentType = "image/jpeg"
		
		File.Copy(Dir, FileName, File.DirInternalCache, "image2.jpg")
		
		fd.Dir= File.DirInternalCache
		fd.FileName="image2.jpg"
'		CropImageInGallery(fd.Dir,fd.FileName)
		files.Add(fd)
		
		
	Catch
		Log(LastException.Message)
		PicIV.Tag=""
	End Try
	
End Sub


Sub JobDone(j As HttpJob)
	If j.Success Then
		Log(j.GetString)
		Select j.JobName
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
				
				If j.GetString == "{""status"":""اثر حدید با موفقیت ساخته شد""}" Then
					
					snake.Initialize("snake", Activity,SaeloZahra.CSB("اثر شما با موفقیت ثبت شد..."), snake.DURATION_LONG)
					snake.Show
					
					Sleep(1000)
					
					Activity.Finish
					
				End If
				
		End Select
	Else
		Select j.JobName
			Case "SubmitJob"
				If j.ErrorMessage == "{""status"":""Bad Request.""}" Then
					ToastMessageShow(SaeloZahra.CSB("فیلدها را تکمیل کنید"), True)
				Else
					ToastMessageShow(j.ErrorMessage, True)
				End If
			Case Else
				ToastMessageShow(j.ErrorMessage, True)
		End Select
		Log(j.ErrorMessage)
	End If
End Sub




Private Sub SubmitBtn_Click
	
	Dim ReshteSlug As String = ReshteMap.Get(ReshteSpinner.SelectedItem)
	
	Dim M1 As Map
	M1.Initialize
	M1.Put("user", Main.UserInfo.Get("id"))
	M1.Put("artCategory", ReshteSlug)
	M1.Put("title", TitleET.Text)
	M1.Put("description", DescET.Text)
	M1.Put("dateCreated", TarikhET.Text)
	M1.Put("productionTeam", TeamET.Text)
	
	SubmitJob.PostMultipart(SaeloZahra.JsonUrl&"effect/Submit/", M1, files)
	
End Sub

Private Sub PicBtn_Click
	cc.Show("image/*", "تصویر مورد نظر خود را انتخاب کنید")
End Sub


Sub ime1_HeightChanged (NewHeight As Int, OldHeight As Int)
		
	ScrollView1.SetLayout(0,SaeloZahra.MaterialActionBarHeight,100%x,NewHeight-SaeloZahra.MaterialActionBarHeight+SaeloZahra.StatusBarHeight)
	
End Sub


Private Sub DateFab_Click
	Dim pdpd As ParsDatePickerDialog
	pdpd.Initialize("pdpd", 1401, 1300, SaeloZahra.Font, SaeloZahra.ColorDark, "ثبت", "لغو", "امروز")
	pdpd.show
End Sub

Sub pdpd_DateSelected(PersianYear As Int,PersianMonth As Int,PersianDay As Int)
	TarikhET.Text = PersianYear&"/"&PersianMonth&"/"&PersianDay
End Sub