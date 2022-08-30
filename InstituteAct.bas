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
	Dim InsID As Int
End Sub

Sub Globals
	Private CF As Hitex_FlexibleSpace
	Private XML As XmlLayoutBuilder
	Dim ToolBar As Hitex_Toolbar
	Dim customBrowser As JK_CustomTabsBrowser
	Dim Config 	As Amir_SliderConfig
	Dim Show 	As Amir_SliderShow
	
	Dim InsJob, ImageJob As HttpJob
	
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
	
	Dim siteAddress As String
	Dim institute_name As String
End Sub

Sub Activity_Create(FirstTime As Boolean)
	
	ProgressDialogShow(SaeloZahra.csb("در حال بارگزاری..."))
	
	Activity.LoadLayout("SingleAsaarLayout")
	CF.Panel.LoadLayout("SingleProductPanelLayout")
	CF.CardElevation=0
	CF.CardBackgroundColor=Colors.Transparent
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
	
	
	ImageJob.Initialize("ImageJob", Me)
	InsJob.Initialize("InsJob", Me)
	InsJob.Download(SaeloZahra.JsonUrl&"institute/"&InsID)
	Log(SaeloZahra.JsonUrl&"institute/"&InsID)


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
	
	
	customBrowser.Initialize
	customBrowser.ToolbarColor = SaeloZahra.Color
	customBrowser.ShowTitle = True
	customBrowser.Build
	
	
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub









Sub Responsive
	
	RelatedTitleLBL.TextColor=Colors.DarkGray
	RelatedTitleLBL.Text=SaeloZahra.CSBTitle("اخبار "&institute_name)
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
	
	ProgressDialogHide
	
	Log(j.JobName&" | "&j.Success)
	
	If J.Success Then
		Select j.JobName
			Case "InsJob"
				Dim parser As JSONParser
				parser.Initialize(J.GetString)
				Dim jRoot As Map = parser.NextObject
				Dim FirstPic As String = jRoot.Get("FirstPic")
				Dim SecondPic As String = jRoot.Get("SecondPic")
				
				Dim SliderHTML As String = File.ReadString(File.DirAssets, "slider.html")
				Dim contents As List = jRoot.Get("contents")
				For Each colcontents As Map In contents
					Dim cover As String = colcontents.Get("cover")
					Dim contents_id As String = ""'colcontents.Get("id")
'					Dim createdAt As String = colcontents.Get("createdAt")
'					Dim like_count As Int = colcontents.Get("like_count")
'					Dim tag As String = colcontents.Get("tag")
					Dim title As String = colcontents.Get("title")
'					Dim category As String = colcontents.Get("category")
'					Dim lead As String = colcontents.Get("lead")
'					Dim content As String = colcontents.Get("content")
'					Dim view_count As Int = colcontents.Get("view_count")
					
					SliderHTML = SliderHTML &" <a href='http://ins_news/"&contents_id&"'><img src='"&SaeloZahra.SiteUrl&cover&"'><h3>"&title&"</h3></a>"
					
					ImagesSliderPanel.SetVisibleAnimated(313,True)
				Next
				Dim institute As Map = jRoot.Get("institute")
'				Dim id As Int = institute.Get("id")
				institute_name = institute.Get("name")
				Dim logo As String = SaeloZahra.SiteUrl&institute.Get("logo")
				Dim description As String = institute.Get("description")
				Dim instituteAddress As String = institute.Get("instituteAddress")
				Dim instituteRegistrationNumber As String = institute.Get("instituteRegistrationNumber")
				Dim SocialNetwork As List = institute.Get("SocialNetwork")
				For Each colSocialNetwork As Map In SocialNetwork
					Dim SocialName As String = colSocialNetwork.Get("SocialName")
					Dim SocialUrl As String = colSocialNetwork.Get("SocialUrl")
				Next
'				Dim RegistrationRole As String = institute.Get("RegistrationRole")
				Dim email As String = institute.Get("email")
'				Dim directorMembers As String = institute.Get("directorMembers")
				siteAddress = institute.Get("siteAddress")
'				Dim picture As List = institute.Get("picture")
'				For Each colpicture As Map In picture
'					Dim pic As String = colpicture.Get("pic")
'					Dim title As String = colpicture.Get("title")
'				Next
				
				
				
				username = institute.Get("admin_username")
				honarmand_name = institute.Get("admin_name")
				
				
				phone_number = ""
				AvatarWV.LoadHtml("<html><body style='margin:Auto; border-radius:50%;'><img src='"&SaeloZahra.SiteUrl&SecondPic&"' style='position:absolute; width:100%; height:100%; left:0; top:0; border-radius:50%; object-fit:cover;' /></body></html>")
				BioLbl.Text = SaeloZahra.CSB("‌سایت: "&siteAddress.Replace("https://", "").Replace("http://", "").Replace("/", ""))
				CityLbl.Text = SaeloZahra.CSB(institute.Get("city"))
				NameLbl.Text = SaeloZahra.CSB("مدیر: ")&SaeloZahra.CSBtitle(honarmand_name)
				
				
				Tag1Lbl.Text = institute.Get("category")
				Tag2Lbl.Text = instituteRegistrationNumber
				CategoryLbl.Text = institute.Get("YearCreated")
				
				Dim CSBText As CSBuilder
				CSBText.Initialize.Bold.Size(28).Append(institute_name).Append(CRLF).Pop.Pop.Append(Regex.Replace("<[^>]*>",description," ")).Append(CRLF).Size(18).Color(Colors.DarkGray)
				CSBText.Bold.Append("آدرس: ").Pop.Append(instituteAddress).Append(CRLF)
				CSBText.Bold.Append("وب‌سایت: ").Pop.Append(siteAddress).Append(CRLF).Size(14).Color(Colors.LightGray)
				CSBText.Bold.Append("پست‌الکترونیک: ").Pop.Append(email).Append(CRLF)
				CSBText.Bold.Append("واتس‌آپ: ").Pop.Append(whatsapp).Append(CRLF)
				CSBText.Bold.Append("‌اینستاگرام: ").Pop.Append(instagram).Append(CRLF)
				CSBText.Append("تعداد بازدید: ").Bold.Append(institute.Get("view_count")).Append(CRLF)
				CSBText.Append("تعداد پسند: ").Bold.Append(institute.Get("like_count")).Append(CRLF)
				CSBText.PopAll
				TextLbl.Text= CSBText
				
				Log(logo)
				PIC_WV.LoadHtml("<html><body style='margin:Auto; border-radius:14px; overflow:hidden;'><img src='"&SaeloZahra.SiteUrl&FirstPic&"' style='position:absolute; width:100%; height:100%; left:0; top:0; border-radius:14px; object-fit:cover;' /></body></html>")
				SaeloZahra.SetCornerRadii(PIC_WV, 14,14,14,14,14,14,14,14)
				ImageJob.Download(logo)
				
				CF.Title = SaeloZahra.CSBTitle("   "&institute_name)
				
				RelatedWV.LoadHtml(SliderHTML&"    </div> </body> </html>")
					
				
				Responsive
				
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
	customBrowser.CreateNewTab(siteAddress)
'	SaeloZahra.I.Initialize(SaeloZahra.I.ACTION_VIEW, "tel:"&phone_number)
'	StartActivity(SaeloZahra.I)
End Sub
Sub CF_LongClick As Boolean
	ToastMessageShow("وب سایت موسسه",False)
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

	Menu.Add2(2,0,"وب‌سایت موسسه",XML.GetDrawable("twotone_thumb_up_white_24")).SetShowAsAction(2)
	Menu.Add2(2,1,"ارتباط با موسسه",XML.GetDrawable("twotone_chat_white_24")).SetShowAsAction(2)
'	Menu.Add2(2,3,"پروفایل",XML.GetDrawable("twotone_account_circle_white_24")).SetShowAsAction(2)
	
End Sub


Sub ToolBar_MenuItemClick (Item As Hi_MenuItem)
	Log(Item.ItemId)
	Select Item.ItemId
'		Case 1
'			If LoginAct.YourID<>"" Then
'				WVAct.WVTitle 	= "مکالمه با "&seller_name
'				WVAct.WVURL 	= SaeloZahra.SiteUrl&"chat/pm/"&seller_id&"?hidetitle=true&username="&File.ReadString(SaeloZahra.Dir, "username")&"&password="&File.ReadString(SaeloZahra.Dir, "password")
'				StartActivity(WVAct)
'			Else
'				CallSubDelayed(MainAct,"LoginKon")
'			End If
		Case 3
			ToastMessageShow(username&" "&phone_number,True)
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
	Log(Url)
	
	If SaeloZahra.WVRoles(Url) == Url Then
		customBrowser.CreateNewTab(Url)
	End If
	
	Return True
End Sub