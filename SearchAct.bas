B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=10.2
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: 	False
	#IncludeTitle: 	True
	#Extends: android.support.v7.app.AppCompatActivity
#End Region
	
Sub Process_Globals
	Dim KeyWord As String
End Sub

Sub Globals
	Dim SearchJob As HttpJob
	Dim Config 	As Amir_SliderConfig
	Dim Show 	As Amir_SliderShow
	Dim X1 As XmlLayoutBuilder
'	Dim LV As Hitex_LayoutView
	Private ActionBar As ACToolBarDark
	Private LoadingWV As WebView
	Dim LvItemList As List
End Sub

Sub Activity_Create(FirstTime As Boolean)
	
	Activity.LoadLayout("SearchLayout")
	
	LoadingWV.LoadHtml("<body> <img style='position:absolute; top:0; left:0; width:100%; height:100%;' src='file:///android_asset/loading_app.gif' > <img style='' src='file:///android_asset/load.gif' ></body>")
	ActionBar.Title=SaeloZahra.CSBTitle("جستجو")
	ActionBar.Color=SaeloZahra.Color
	ActionBar.NavigationIconDrawable = X1.GetDrawable("round_arrow_back_white_24")
	
	LvItemList.Initialize
	
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
	
	
	ProgressDialogShow(SaeloZahra.csb("در حال جستجو..."))
'	LvItemList.Add(CreateMap("id":1,"title":"سلام خلای دیووووووووونه","pic":"https://peyjoor.com/uploads/products/1399/11/1611316757_154458.jpg"))
	Log(SaeloZahra.JsonUrl&"hafez/search/"&KeyWord)
	SearchJob.Initialize("SearchJob",Me)
	SearchJob.Download(SaeloZahra.JsonUrl&"hafez/search/"&KeyWord)
	Wait For (SearchJob) JobDone(j As HttpJob)
	If j.Success Then
		Dim parser As JSONParser
		parser.Initialize(j.GetString)
		Dim root As List = parser.NextArray
		For Each colroot As Map In root
'			Dim id As Int = colroot.Get("id")
			Dim title As String = colroot.Get("title")
			Log(title)
'			Dim MyType As String = colroot.Get("type")
'			Dim subtype As String = colroot.Get("subtype")
'			Dim url As String = colroot.Get("url")
			LvItemList.Add(colroot)
		Next
	End If
	j.Release
	
	LoadingWV.SetVisibleAnimated(313,False)
	
	ProgressDialogHide
	
End Sub

Sub Activity_Resume
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

Sub Activity_Pause (UserClosed As Boolean)

End Sub
