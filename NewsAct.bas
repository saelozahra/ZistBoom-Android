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
	Dim NewsID As Int
End Sub

Sub Globals
	Dim Loved As Boolean = False
	Dim LoveList As List
	Private CF As Hitex_FlexibleSpace
	Private XML As XmlLayoutBuilder
	Dim ToolBar As Hitex_Toolbar
	
	Dim Config 	As Amir_SliderConfig
	Dim Show 	As Amir_SliderShow
	
	Dim NewsJob, ImageJob, LoveJob As HttpJob
	
	Private TextPanel As Panel
	Private TextLbl As Label
	Private ImagesSliderPanel As Panel
	
	Private Tag1Lbl, Tag2Lbl, Tag3Lbl, CategoryLbl As Label
	
	Private  AvatarWV, PIC_WV As WebView
	
	Private HonarmandPanel As Panel
	Private NameLbl As Label
	Private BioLbl As Label
	Private CityLbl As Label
	
End Sub

Sub Activity_Create(FirstTime As Boolean)
	
	If File.Exists(SaeloZahra.Dir, "LoveAsaar") Then
		LoveList = File.ReadList(SaeloZahra.Dir, "LoveAsaar")
		For Each n As Int In LoveList
			If n == NewsID Then Loved = True
		Next
	Else
		LoveList.Initialize
	End If
	
	Activity.LoadLayout("SingleAsaarLayout")
	CF.Panel.LoadLayout("SingleProductPanelLayout")
	CF.CardElevation=0
	CF.CardBackgroundColor=Colors.Transparent
'	CF.ImageBitmap = LoadBitmap(File.DirAssets,"load.gif")
	CF.ImageScaleType = CF.SCALE_CENTER_CROP
	If Loved Then
		CF.Icon = XML.GetDrawable("baseline_thumb_up_white_24")
	Else
		CF.Icon = XML.GetDrawable("twotone_thumb_up_white_24")
	End If
	
	CF.SetToolbarColor(SaeloZahra.ColorDark,SaeloZahra.ColorLightTransparent)
	CF.SetFabColor(SaeloZahra.ColorAccent,SaeloZahra.ColorLightTransparent)
	
	
	Dim T As Hitex_Toolbar = CF.ToolbarDark

	ToolBar.Initialize("Toolbar")
	Dim XML As XmlLayoutBuilder
	Dim Jo = T.Parent As JavaObject
	T.RemoveView
	Jo.RunMethod("addView",Array(ToolBar))
	ToolBar.Height = 56dip
	ToolBar.SetSupportActionBar
	
	ToolBar.Color = Colors.Transparent
	ToolBar.NavigationIcon = XML.GetDrawable("round_arrow_back_white_24")

	Dim wcc As DefaultWebChromeClient
	wcc.Initialize("wcc")
	
	
	LoveJob.Initialize("LoveJob", Me)
	
	ImageJob.Initialize("ImageJob", Me)
	NewsJob.Initialize("NewsJob", Me)
	NewsJob.Download(SaeloZahra.JsonUrl&"news/"&NewsID)
	Log(SaeloZahra.JsonUrl&"news/"&NewsID)


	CategoryLbl.TextColor=Colors.DarkGray
	CategoryLbl.Typeface = SaeloZahra.fontBold
	Tag1Lbl.SetLayout((CategoryLbl.Left+CategoryLbl.Width+5dip),Tag1Lbl.top,Tag1Lbl.Width,Tag1Lbl.Height) : Tag1Lbl.Color=SaeloZahra.ColorAccent : Tag1Lbl.Typeface=SaeloZahra.Font
	Tag2Lbl.SetLayout(Tag1Lbl.Left+Tag1Lbl.Width+14dip,Tag2Lbl.top,Tag2Lbl.Width+10dip,Tag2Lbl.Height) : Tag2Lbl.Color=SaeloZahra.ColorAccent : Tag2Lbl.Typeface=SaeloZahra.Font
	
	
	
	TextLbl.Typeface = SaeloZahra.font
	TextLbl.Gravity = Gravity.RIGHT
	
	
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
	
	TextPanel.SetLayout(3%x,TextPanel.Top,83%x,TextPanel.Height)
	TextLbl.SetLayout(1%x,TextLbl.Top,78%x,TextLbl.Height)
	ImagesSliderPanel.SetLayout(3%x,ImagesSliderPanel.Top,83%x,ImagesSliderPanel.Height)
	
	SaeloZahra.SetStatusBarColor(SaeloZahra.Color)
	
	Responsive
	
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub









Sub Responsive
	
	PIC_WV.SetLayout(0,0,ImagesSliderPanel.Width,ImagesSliderPanel.Height)
	
	Dim SU As StringUtils
	TextLbl.Height = SU.MeasureMultilineTextHeight(TextLbl,TextLbl.text)+5%y
	TextPanel.Height = TextLbl.Height

	Tag1Lbl.Top = TextLbl.Height-5%y
	Tag2Lbl.Top = TextLbl.Height-5%y
	CategoryLbl.Top = TextLbl.Height-5%y
	
	ImagesSliderPanel.Top=TextPanel.top+TextPanel.Height+20dip
	
	HonarmandPanel.SetLayout(ImagesSliderPanel.Left, ImagesSliderPanel.top+ImagesSliderPanel.Height+20dip, 83%x, HonarmandPanel.Height)
	
	CF.Panel.Height = HonarmandPanel.top+HonarmandPanel.Height+20dip
	
	
End Sub










Sub jobDone(J As HttpJob)
	Log(j.JobName&" | "&j.Success)
	If J.Success Then
		Select j.JobName
			Case "NewsJob"
				
				Dim parser As JSONParser
				parser.Initialize(J.GetString)
				Dim jRoot As Map = parser.NextObject
'				Dim createdAt As String = jRoot.Get("createdAt")
				
				Dim PICURL As String = SaeloZahra.SiteUrl&jRoot.Get("cover")
				
				AvatarWV.LoadHtml("<html><body style='margin:Auto; border-radius:50%;'><img src='"&PICURL&"' style='position:absolute; width:100%; height:100%; left:0; top:0; border-radius:50%; object-fit:cover;' /></body></html>")
				
				Dim parser As JSONParser
				parser.Initialize(J.GetString)
				Dim jRoot As Map = parser.NextObject
				
				Dim components() As String
				components = Regex.Split(",", jRoot.Get("tag"))
				If components.Length == 1 Then
					Tag1Lbl.Text = components(1)
				Else If components.Length == 2 Then
					Tag1Lbl.Text = components(0)
					Tag2Lbl.Text = components(1)
				Else
					Tag1Lbl.Text = jRoot.Get("tag")
				End If
				
				CategoryLbl.Text = jRoot.Get("category")
				
				Dim CSBText As CSBuilder
				CSBText.Initialize.Bold.Size(24).Color(Colors.Black).Append(jRoot.Get("title")).Append(CRLF).PopAll.Size(20).Append(jRoot.Get("lead")).Append(CRLF).Color(Colors.DarkGray).Size(18).Color(Colors.DarkGray).Append(Regex.Replace("<[^>]*>",jRoot.Get("content")," ")).PopAll
				TextLbl.Text= CSBText
				
				Log(PICURL)
				PIC_WV.LoadHtml("<html><body style='margin:Auto; border-radius:14px; overflow:hidden;'><img src='"&PICURL&"' style='position:absolute; width:100%; height:100%; left:0; top:0; border-radius:14px; object-fit:cover;' /></body></html>")
				SaeloZahra.SetCornerRadii(PIC_WV, 14,14,14,14,14,14,14,14)
				ImageJob.Download(PICURL)
				
				CF.Title = SaeloZahra.CSBTitle("   "&jRoot.Get("title"))
				
				ImagesSliderPanel.SetVisibleAnimated(313,True)
				
				Responsive
				
			Case "LoveJob"
				Loved=True
				LoveList.Add(NewsID)
'				TODO: Update Loves Realtime
				File.WriteList(SaeloZahra.Dir, "LoveAsaar", LoveList )
				Activity.Finish
				StartActivity(Me)
			Case "ImageJob"
				Try
					CF.ImageBitmap = J.GetBitmap
				Catch
					CF.ImageBitmap = LoadBitmap(File.DirAssets, "icon.png")
					Log(LastException)
				End Try
		End Select
	Else
		ToastMessageShow(SaeloZahra.CSB("خطا در بارگزاری"),True)
		ToastMessageShow(J.ErrorMessage,False)
	End If
	J.Release
	
End Sub










Sub CF_Click
	LoveJob.PostString(SaeloZahra.SiteUrl&"news/"&NewsID,"")
End Sub

Sub CF_LongClick As Boolean
	ToastMessageShow("تماس با فروشنده",False)
	Return True
End Sub

Sub CF_NavigationOnClick
	Activity.Finish
	SaeloZahra.SetAnimation("zoom_enter","zoom_exit")
End Sub

Sub ToolBar_NavigationClick
	Activity.Finish
	SaeloZahra.SetAnimation("zoom_enter","zoom_exit")
End Sub

Sub ToolBar_NavigationOnClick
	Activity.Finish
	SaeloZahra.SetAnimation("zoom_enter","zoom_exit")
End Sub

Sub Activity_KeyPress (KeyCode As Int) As Boolean
	If KeyCode==KeyCodes.KEYCODE_BACK Then
		CF_NavigationOnClick
		Return False
	Else
		Return True
	End If
End Sub

Sub Activity_CreateOptionsMenu (Menu As Hi_Menu)

	Menu.Add2(2,1,"نظرات",XML.GetDrawable("twotone_chat_white_24")).SetShowAsAction(2)
	
End Sub


Sub ToolBar_MenuItemClick (Item As Hi_MenuItem)
	Log(Item.ItemId)
	Select Item.ItemId
		Case 1
	End Select
End Sub

#IF JAVA

  import ir.hitexroid.material.x.others.Hi_Menu;
  import android.view.Menu;

   public boolean _onCreateOptionsMenu(Menu menu) {
     if (processBA.subExists("activity_createoptionsmenu")) {
       processBA.raiseEvent2(this, true, "activity_createoptionsmenu", false, new Hi_Menu(menu));
       return true;
     } else {
       return false;
     }   
    }

 #End If
 
