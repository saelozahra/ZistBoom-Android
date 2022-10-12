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
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.

End Sub

Sub Globals
	Private ImageView1 As ImageView
	Private UserNameFLET As DSFloatLabelEditText
	Private PasswordFLET As DSFloatLabelEditText
	Private RegBtn As ACButton
	Private LoginBtn As ACButton
End Sub

Sub Activity_Create(FirstTime As Boolean)
	
	Activity.LoadLayout("LoginAct")
	Activity.Color=SaeloZahra.Color
	ImageView1.SetBackgroundImage(LoadBitmapResize(File.DirAssets, "login.png", ImageView1.Width, ImageView1.Height, True)).Gravity=Gravity.CENTER
	
	Dim Csl As CSBuilder
	Csl.Initialize
'	Csl.Typeface(SaeloZahra.Font).Append("ورود ").Typeface(Typeface.FONTAWESOME).Append(Chr(0xF234))
	Csl.Typeface(SaeloZahra.Font).Append("ورود ").Typeface(Typeface.FONTAWESOME).Append(Chr(0xF090)).PopAll
	LoginBtn.Text = Csl
	
'	Menu.Add2(3,1,"ورود",		X1.GetDrawable("round_login_white_24") 				).ShowAsAction = 2
'	Menu.Add2(4, 4, "ثبت‌نام", X1.GetDrawable("twotone_app_registration_white_24") ).ShowAsAction = 2
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub


Private Sub PasswordFLET_EnterPressed
	
End Sub