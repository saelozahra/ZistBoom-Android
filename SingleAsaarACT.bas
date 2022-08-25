B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=10.2
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: True
	#Extends: android.support.v7.app.AppCompatActivity
#End Region

Sub Process_Globals
	Dim AsaarID As String
End Sub

Sub Globals
	Dim Loved As Boolean = False
	Dim LoveList As List
	Private CF As Hitex_FlexibleSpace
	Private XML As XmlLayoutBuilder
	Dim ToolBar As Hitex_Toolbar
	
	Dim Config 	As Amir_SliderConfig
	Dim Show 	As Amir_SliderShow
	
	Dim AsarJob, ImageJob, LoveJob As HttpJob
	
	Dim phone_number As String
	Dim username As String
	Dim honarmand_name As String
	
	Private TextPanel As Panel
	Private TextLbl As Label
	Private ImagesSliderPanel As Panel
	
	
	Private RelatedPanel As Panel
	Private RelatedTitleLBL As Label
	Private Tag1Lbl, Tag2Lbl, Tag3Lbl, CategoryLbl As Label
	
	Private RelatedWV, PIC_WV As WebView
	
	Dim WebViewExtras1 As WebViewExtras
	
	Private HonarmandPanel As Panel
	Private NameLbl As Label
	Private BioLbl As Label
	Private CityLbl As Label
	Private AvatarWV As WebView
	
End Sub

Sub Activity_Create(FirstTime As Boolean)
	
	If File.Exists(SaeloZahra.Dir, "LoveAsaar") Then
		LoveList = File.ReadList(SaeloZahra.Dir, "LoveAsaar")
		For Each n As Int In LoveList
			If n == AsaarID Then Loved = True
		Next
	Else
		LoveList.Initialize
	End If
	
	Activity.LoadLayout("SingleAsaarLayout")
	CF.Panel.LoadLayout("SingleProductPanelLayout")
	CF.CardElevation=0
	CF.CardBackgroundColor=Colors.Transparent
	CF.ImageBitmap = LoadBitmap(File.DirAssets,"load.gif")
	CF.ImageScaleType = CF.SCALE_CENTER_CROP
	CF.Icon = XML.GetDrawable("twotone_perm_phone_msg_white_24")
	CF.SetToolbarColor(SaeloZahra.ColorDark,SaeloZahra.ColorLightTransparent)
	CF.SetFabColor(SaeloZahra.ColorAccent,SaeloZahra.ColorLightTransparent)
	CF.Title="     "&Application.LabelName
	
	
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
	
	WebViewExtras1.Initialize(RelatedWV)
	WebViewExtras1.SetWebChromeClient(wcc)
	
	LoveJob.Initialize("LoveJob", Me)
	
	ImageJob.Initialize("ImageJob", Me)
	AsarJob.Initialize("AsarJob", Me)
	AsarJob.Download(SaeloZahra.JsonUrl&"asaar/"&AsaarID)
	Log(SaeloZahra.JsonUrl&"asaar/"&AsaarID)


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
	
	RelatedTitleLBL.TextColor=Colors.DarkGray
	RelatedTitleLBL.Text=SaeloZahra.CSBTitle("آثار دیگر این هنرمند")
	RelatedTitleLBL.SetLayout(0,0,RelatedTitleLBL.Width,RelatedTitleLBL.Height)
	RelatedWV.SetLayout(0,RelatedTitleLBL.Height,RelatedPanel.Width,RelatedPanel.Height-10dip)
	
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
	
	RelatedPanel.SetLayout(3%x, CF.Panel.Height, 83%x, RelatedPanel.Height)
	If RelatedPanel.Visible==True Then
		CF.Panel.Height = RelatedPanel.top+RelatedPanel.Height+20dip
	End If
	
End Sub










Sub jobDone(J As HttpJob)
	Log(j.JobName&" | "&j.Success)
	If J.Success Then
		Select j.JobName
			Case "AsarJob"
				Dim parser As JSONParser
				parser.Initialize(J.GetString)
				Dim jRoot As Map = parser.NextObject
				Dim RelatedPosts As List = jRoot.Get("RelatedPosts")
				Dim SliderHTML As String = File.ReadString(File.DirAssets, "slider.html")
				For Each colRelatedPosts As Map In RelatedPosts
'					Dim dateCreated As String = colRelatedPosts.Get("dateCreated")
'					Dim like_count As Int = colRelatedPosts.Get("like_count")
					Dim colRelatedPosts_id As Int = colRelatedPosts.Get("id")
					Dim title As String = colRelatedPosts.Get("title")
					Log("rel: "&title)
					Dim picture As String = colRelatedPosts.Get("picture")
'					Dim view_count As Int = colRelatedPosts.Get("view_count")
					SliderHTML = SliderHTML &" <a href='http://rel/"&colRelatedPosts_id&"'><img src='"&SaeloZahra.SiteUrl&picture&"'><h3>"&title&"</h3></a>"
				Next

				
				Dim SinglePost As Map = jRoot.Get("SinglePost")
				Dim rating As Int = SinglePost.Get("rating")
				Dim title As String = SinglePost.Get("title")
				username = SinglePost.Get("username")
'				Dim productionTeam As String = SinglePost.Get("productionTeam")
				honarmand_name = jRoot.Get("user_name_family")
				
				
				phone_number = jRoot.Get("phone_number")
				AvatarWV.LoadHtml("<html><body style='margin:Auto; border-radius:50%;'><img src='"&SaeloZahra.SiteUrl&jRoot.Get("avatar")&"' style='position:absolute; width:100%; height:100%; left:0; top:0; border-radius:50%; object-fit:cover;' /></body></html>")
				BioLbl.Text = SaeloZahra.CSB(jRoot.Get("bio"))
				CityLbl.Text = SaeloZahra.CSB(jRoot.Get("city"))
				NameLbl.Text = SaeloZahra.CSBtitle(honarmand_name)
				
				
				Tag1Lbl.Text = SinglePost.Get("category")
				Tag2Lbl.Text = jRoot.Get("city")
				CategoryLbl.Text = SinglePost.Get("dateCreated")
				CategoryLbl.Text = CategoryLbl.Text.Replace("-", "/")
				
				Dim CSBText As CSBuilder
				CSBText.Initialize.Append(Regex.Replace("<[^>]*>",SinglePost.Get("description")," ")).Append(CRLF).Size(10).Color(Colors.DarkGray).Append("امتیاز: ").Bold.Append(rating).Append(CRLF).Append("تعداد بازدید: ").Bold.Append(SinglePost.Get("view_count")).Append(CRLF).Append("تعداد پسند: ").Bold.Append(SinglePost.Get("like_count")).PopAll
				TextLbl.Text= CSBText
				
				Dim PICURL As String = SaeloZahra.SiteUrl&SinglePost.Get("picture")
				Log(PICURL)
				PIC_WV.LoadHtml("<html><body style='margin:Auto; border-radius:14px; overflow:hidden;'><img src='"&PICURL&"' style='position:absolute; width:100%; height:100%; left:0; top:0; border-radius:14px; object-fit:cover;' /></body></html>")
				SaeloZahra.SetCornerRadii(PIC_WV, 14,14,14,14,14,14,14,14)
				ImageJob.Download(PICURL)
				
				CF.Title = SaeloZahra.CSBTitle("   "&title)
				
'				SliderHTML = SliderHTML & File.ReadString(File.DirAssets, "slider_2.html") & "<style>#owl-demo .item img{width: 100%; height: 100%; top: 0; left: 0; max-width:none; max-height:none; object-fit:cover; } .owl-buttons {top: 27%;} </style>"
'				RelatedWV.LoadHtml(File.ReadString(File.DirAssets, "slide.html"))
				RelatedWV.LoadHtml(SliderHTML&"    </div> </body> </html>")
					
				ImagesSliderPanel.SetVisibleAnimated(313,True)
				
				Responsive
				
			Case "LoveJob"
				Loved=True
				LoveList.Add(AsaarID)
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
	SaeloZahra.I.Initialize(SaeloZahra.I.ACTION_VIEW, "tel:"&phone_number)
	StartActivity(SaeloZahra.I)
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

'	Menu.Add2(1,2,"مورد علاقه",XML.GetDrawable("twotone_bookmarks_white_24")).SetShowAsAction(2)
	Menu.Add2(2,0,"پسندیدن",XML.GetDrawable("twotone_thumb_up_white_24")).SetShowAsAction(2)
	Menu.Add2(2,1,"نظرات",XML.GetDrawable("twotone_chat_white_24")).SetShowAsAction(2)
'	Menu.Add2(2,3,"پروفایل",XML.GetDrawable("twotone_account_circle_white_24")).SetShowAsAction(2)
	
End Sub


Sub ToolBar_MenuItemClick (Item As Hi_MenuItem)
	Log(Item.ItemId)
	Select Item.ItemId
		Case 0
			If Loved Then
'				@TODO: remove like
'				Log(SaeloZahra.JsonUrl&"wish/remove/"&ProductID&"/products/"&LoginAct.YourID)
'				LoveJob.Download(SaeloZahra.JsonUrl&"wish/remove/"&ProductID&"/products/"&LoginAct.YourID)
			Else
				LoveJob.PostString(SaeloZahra.JsonUrl&"asaar/"&AsaarID,"")
			End If
'		Case 1
'			If LoginAct.YourID<>"" Then
'				WVAct.WVTitle 	= "مکالمه با "&seller_name
'				WVAct.WVURL 	= SaeloZahra.SiteUrl&"chat/pm/"&seller_id&"?hidetitle=true&username="&File.ReadString(SaeloZahra.Dir, "username")&"&password="&File.ReadString(SaeloZahra.Dir, "password")
'				StartActivity(WVAct)
'			Else
'				CallSubDelayed(MainAct,"LoginKon")
'			End If
		Case 3
			ToastMessageShow(honarmand_name, True)
			ToastMessageShow(username, True)
'			ProductsListAct.UserID = seller_id
'			StartActivity(ProductsListAct)
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
 
 
 
 
 
Sub RelatedWV_OverrideUrl (Url As String) As Boolean
	AsaarID = Url.Replace("http://rel/", "")
	StartActivity(Me)
	Return True
 End Sub