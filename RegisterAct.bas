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
	Dim X1 As XmlLayoutBuilder
	Dim Config 	As Amir_SliderConfig
	Dim Show 	As Amir_SliderShow
	
	Dim CityMap as Map
	
	Private ActionBar As ACToolBarDark
	Private NameET As DSFloatLabelEditText
	Private FamilyET As DSFloatLabelEditText
	Private UserNameET As DSFloatLabelEditText
	Private MailET As DSFloatLabelEditText
	Private TelET As DSFloatLabelEditText
	Private PassET1 As DSFloatLabelEditText
	Private PassET2 As DSFloatLabelEditText
	Private CitySpinner As ACSpinner
	Private SubmitBtn As ACButton
	
	Dim CityJob, SubmitJob As HttpJob
	
End Sub

Sub Activity_Create(FirstTime As Boolean)
	
	Activity.LoadLayout("RegisterLayout")

	ActionBar.Title=SaeloZahra.CSBTitle("ثبت نام")
	ActionBar.Color=SaeloZahra.Color
	ActionBar.NavigationIconDrawable = X1.GetDrawable("round_arrow_back_white_24")
	
	NameET.Typeface = SaeloZahra.Font
	FamilyET.Typeface = SaeloZahra.Font
	UserNameET.Typeface = SaeloZahra.Font
	MailET.Typeface = SaeloZahra.Font
	TelET.Typeface = SaeloZahra.Font
	PassET1.Typeface = SaeloZahra.Font
	PassET2.Typeface = SaeloZahra.Font
	SubmitBtn.Typeface = SaeloZahra.Font
	SubmitBtn.SetButtonColors(SaeloZahra.ColorDark, SaeloZahra.Color,Colors.LightGray)
	
	CityMap.Initialize
	
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



Sub JobDone(j As HttpJob)
	If j.Success Then
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
	Else
		ToastMessageShow(j.ErrorMessage, True)
	End If
End Sub




Private Sub SubmitBtn_Click
	
	Dim CitySlug As String = CityMap.Get(CitySpinner.SelectedItem)
	
	Dim M1 As Map
	M1.Initialize
	M1.Put("name", NameET.Text)
	M1.Put("family", FamilyET.Text)
	M1.Put("city", CitySlug)
	M1.Put("username", UserNameET.Text)
	M1.Put("mail", MailET.Text)
	
	SubmitJob.PostMultipart(SaeloZahra.JsonUrl&"register", M1, Null)
	
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