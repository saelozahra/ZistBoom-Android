B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=8.3
@EndOfDesignText@
#IgnoreWarnings:12,10
Sub Process_Globals
	
'	Dim englishName As String = "damaara"
	Dim Dir As String = File.DirInternalCache
	Dim Font As Typeface=Typeface.LoadFromAssets("Samim-FD-WOL.ttf")
	Dim fontBold As Typeface=Typeface.LoadFromAssets("Samim-Bold-FD-WOL.ttf")
	Dim SiteUrl As String = "http://zistboom.farhangi-fars.com/"
	Dim JsonUrl As String = SiteUrl&"api/"
'	Dim SupportNumber As String = "09366208105"
	Dim P As Phone
	Dim Debug As Boolean = False
	Dim R As Reflector
	Dim PI As PhoneIntents
	Dim I As Intent
	Dim JO As JavaObject
	Dim MaterialActionBarHeight,StatusBarHeight As Int
	Dim XUI As XUI
	Dim Color 		As Int
	Dim ColorDark 	As Int
	Dim ColorLight 	As Int = 0xFF00A693
	Dim ColorLightTransparent As Int = 0xAA00A693
	Dim ColorAccent As Int
	
End Sub

Sub Gradiant As GradientDrawable
	Dim Gradient1 As GradientDrawable
	Dim Clrs(2) As Int
'	Clrs(0) = 0x9EE5EF7B
'	Clrs(1) = 0x9EA1B300
	Clrs(0) = 0x9EFFECB3
	Clrs(1) = 0xBEB08403
	Gradient1.Initialize("TR_BL", Clrs)
	Return Gradient1
End Sub


'xui is a global XUI variable.
Sub CreateRoundBitmap (Input As B4XBitmap, Size As Int) As B4XBitmap
	If Input.Width <> Input.Height Then
		'if the image is not square then we crop it to be a square.
		Dim l As Int = Min(Input.Width, Input.Height)
		Input = Input.Crop(Input.Width / 2 - l / 2, Input.Height / 2 - l / 2, l, l)
	End If
	Dim c As B4XCanvas
	Dim xview As B4XView = XUI.CreatePanel("")
	xview.SetLayoutAnimated(0, 0, 0, Size, Size)
	c.Initialize(xview)
	Dim path As B4XPath
	path.InitializeOval(c.TargetRect)
	c.ClipPath(path)
	c.DrawBitmap(Input.Resize(Size, Size, False), c.TargetRect)
	c.RemoveClip
	c.DrawCircle(c.TargetRect.CenterX, c.TargetRect.CenterY, c.TargetRect.Width / 2 - 2dip, ColorLight, False, 5dip) 'comment this line to remove the border
	c.Invalidate
	Dim res As B4XBitmap = c.CreateBitmap
	c.Release
	Return res
End Sub

Sub SetCornerRadii(v As View, Rx_TopLeft As Float, Ry_TopLeft As Float, Rx_TopRight As Float, Ry_TopRight As Float, Rx_BottomRight As Float, Ry_BottomRight As Float, Rx_BottomLeft As Float, Ry_BottomLeft As Float)
	Dim JO As JavaObject = v.Background
	If v.Background Is ColorDrawable Or v.Background Is GradientDrawable Then
		JO.RunMethod("setCornerRadii", Array As Object(Array As Float(Rx_TopLeft, Ry_TopLeft, Rx_TopRight, Ry_TopRight, Rx_BottomRight, Ry_BottomRight, Rx_BottomLeft, Ry_BottomLeft)))
	End If
End Sub

Sub SeNoghte(adad As Int)As String
	Return NumberFormat2( adad,3,0, 0,True)
End Sub

Sub inventory(str As String)As String
	Select str
		Case "available"
			Return "موجود"
		Case "comingsoon"
			Return "بزودی می‌آید"
		Case "unavailable"
			Return "ناموجود"
	End Select
End Sub

Sub ParseInt(in1 As String) As Int
	If in1 == Null Or in1 == "null" Then in1 = 0
	If in1.Contains(".") Then
		in1 = in1.SubString2(0,in1.IndexOf("."))
	End If
	Dim Adadesh As Int
	Adadesh = Bit.ParseInt(in1,10)
	Return Adadesh
End Sub

'Sub pishhomare(pish As String) As String
'	
'	If pish.StartsWith("0990") Or pish.StartsWith("0991") Or pish.StartsWith("0992") Or pish.StartsWith("091") Then
'		Return "hamrah"
'	else If pish.StartsWith("090") Or pish.StartsWith("093") Then
'		Return "irancell"
'	Else If pish.StartsWith("0920") Or pish.StartsWith("0921") Or pish.StartsWith("0922") Then
'		Return "rightel"
'	Else
'		Return "other"
'	End If
'	
'End Sub

Sub WVRoles(URL As String) As String
	
	If URL.Contains(SiteUrl&"asaar/") Then
		SingleAsaarACT.AsaarID=URL.Replace(SiteUrl&"asaar/","")
		StartActivity(SingleAsaarACT)
	else If URL.Contains("http://ins_news/") Then
		NewsAct.NewsID=URL.Replace("http://ins_news/","")
'		@todo: ins_News
		StartActivity(NewsAct)
	else If URL.Contains(SiteUrl&"city/") Then
		WebViewACT.Link = URL&"?for_mobile=true"
		WebViewACT.PageTitle = "زیست‌بوم شهرستان"
		StartActivity(WebViewACT)
	else If URL.Contains(SiteUrl&"profile/") Then
		WebViewACT.Link = URL&"?for_mobile=true"
		WebViewACT.PageTitle = "پروفایل هنرمند"
		StartActivity(WebViewACT)
	else If URL.Contains(SiteUrl&"chat/") Then
		WebViewACT.Link = URL&"?for_mobile=true"
		WebViewACT.PageTitle = "گفتگو"
		StartActivity(WebViewACT)
	else If URL.Contains(SiteUrl&"news/") Then
		NewsAct.NewsID=URL.Replace(SiteUrl&"news/","")
		StartActivity(NewsAct)
	else If URL.Contains(SiteUrl&"institute/") Then
		InstituteAct.InsID=URL.Replace(SiteUrl&"institute/","")
		StartActivity(InstituteAct)
	else If URL.Contains("tel:") Then
		I.Initialize(I.ACTION_VIEW, URL)
		StartActivity(I)
	Else
		Return URL
	End If
	
End Sub

Sub getCurrentActivity As Activity
	Dim R1 As Reflector
	R1.Target = R1.GetActivityBA
	Return R1.GetField("vg")
End Sub

Public Sub SetAlpha (View As B4XView, Level As Float)
    #if B4A
	Dim JO As JavaObject = View
	Dim alpha As Float = Level
	JO.RunMethod("setAlpha", Array(alpha))
    #Else If B4J
    Dim n As Node = View
    n.Alpha = Level
    #else if B4i
    Dim v As View = View
    v.Alpha = Level
    #End If
End Sub

Sub Replace0With98(tel As String) As String
	If tel.StartsWith("98") Then
		Log("09"&tel.SubString2(1,tel.Length))
		Return "09"&tel.SubString2(1,tel.Length)
	Else
		Return tel
	End If
End Sub

Sub CD( Color1 As Int ) As ColorDrawable
	Dim cd2 As ColorDrawable
	cd2.Initialize2(Color1,14dip,1dip,ColorDark)
	Return cd2
End Sub

Sub tarikheKhafan(timeStamp As Long) As String
	
	Try
	
		Dim shamsiDate As PersianDate
		Dim KhodeTarikh As String = ConvertEnglish(shamsiDate.getDate(DateTime.GetYear(timeStamp),DateTime.GetMonth(timeStamp),DateTime.GetDayOfMonth(timeStamp),"/"))
		KhodeTarikh=KhodeTarikh.Replace("1399/","")
		KhodeTarikh=KhodeTarikh.Replace("1400/","")
		KhodeTarikh=KhodeTarikh.Replace("1401/","")
'		Log("KhodeTarikh:  "&KhodeTarikh)
		Dim RoozeTarikh As String = KhodeTarikh.SubString2(KhodeTarikh.IndexOf("/"),KhodeTarikh.Length).Replace("/","")
			
		Dim Mahesh As String = KhodeTarikh.SubString2(0,KhodeTarikh.IndexOf("/"))
		Mahesh = esmeMah(Mahesh.Replace("/",""))
		
		Return esmeRoozeHafte(timeStamp)&" " &ConvertPersian(RoozeTarikh)&" "&esmeMah(Mahesh)
		
	Catch
		Log("نتونست تاریخو در بیاره"&LastException)
		Return shamsiDate.getDate(DateTime.GetYear(timeStamp),DateTime.GetMonth(timeStamp),DateTime.GetDayOfMonth(timeStamp),"/")
	End Try
	
End Sub


Sub ConvertPersian( Text As String ) As String
	Return Text.Replace( "0" , "۰" ).Replace( "1" , "۱" ).Replace( "2" , "۲" ).Replace( "3" , "۳" ).Replace( "4" , "۴" ).Replace( "5" , "۵" ).Replace( "6" , "۶" ).Replace( "7" , "۷" ).Replace( "8" , "۸" ).Replace( "9" , "۹" )
End Sub

Sub ConvertEnglish( Text As String ) As String
	Return Text.Replace( "۰" , "0" ).Replace( "۱" , "1" ).Replace( "۲" , "2" ).Replace( "۳" , "3" ).Replace( "۴" , "4" ).Replace( "۵" , "5" ).Replace( "۶" , "6" ).Replace( "۷" , "7" ).Replace( "۸" , "8" ).Replace( "۹" , "9" )
End Sub


Sub esmeMah(input As Int)As String
		
	Select input
		
		Case 1
			Return "فروردین"
		Case 2
			Return "اردیبهشت"
		Case 3
			Return "خرداد"
		Case 4
			Return "تیر"
		Case 5
			Return "مرداد"
		Case 6
			Return "شهریور"
		Case 7
			Return "مهر"
		Case 8
			Return "آبان"
		Case 9
			Return "آذر"
		Case 10
			Return "دی"
		Case 11
			Return "بهمن"
		Case 12
			Return "اسفند"
		Case Else
			Return input
	End Select
	
End Sub




'Sub chandom(input As Int)As String
'		
'	Select input
'		
'		Case 1
'			Return "اول"
'		Case 2
'			Return "دوم"
'		Case 3
'			Return "سوم"
'		Case 4
'			Return "چهارم"
'		Case 5
'			Return "پنجم"
'		Case 6
'			Return "ششم"
'		Case 7
'			Return "هفتم"
'		Case 8
'			Return "هشتم"
'		Case 9
'			Return "نهم"
'		Case 10
'			Return "دهم"
'		Case 11
'			Return "یازدهم"
'		Case 12
'			Return "دوازدهم"
'		Case 13
'			Return "سیزدهم"
'		Case 14
'			Return "چهاردهم"
'		Case 15
'			Return "پانزدهم"
'		Case 16
'			Return "شانزدهم"
'		Case 17
'			Return "هفدهم"
'		Case 18
'			Return "هجدهم"
'		Case 19
'			Return "نوزدهم"
'		Case 20
'			Return "بیستم"
'		Case Else
'			Return input
'	End Select
'	
'End Sub






Sub mohasebe_tarikh(time_time As Long) As String
	
	Dim mohasebe_daghighe As String
	mohasebe_daghighe = DateUtils.PeriodBetween(time_time,DateTime.Now).Minutes
	
	Dim mohasebe_saat As String
	mohasebe_saat = DateUtils.PeriodBetween(time_time,DateTime.Now).Hours
	
'	Dim saat_daghigh As String
'	saat_daghigh=DateTime.GetHour(time_time)&":"&DateTime.GetMinute(time_time)
	
	Dim mohasebe_rooz As String
	mohasebe_rooz = DateUtils.PeriodBetween(time_time,DateTime.Now).Days
	
	Dim mohasebe_Months As String
	mohasebe_Months = DateUtils.PeriodBetween(time_time,DateTime.Now).Months
	
	
	If mohasebe_Months > 1 Then
		Return mohasebe_Months &" ماه و "&mohasebe_rooz&" روز پیش "
	Else If mohasebe_rooz>1 Then
		Return mohasebe_rooz&" روز پیش "
	Else if mohasebe_saat>1 Then
		Return mohasebe_saat & " ساعت پیش "
	Else
		Return mohasebe_daghighe & " دقیقه پیش "
	End If
'	DateUtils.PeriodBetween(timestamp_cli,DateTime.Now).Days & " روز و " & DateUtils.PeriodBetween(timestamp_cli,DateTime.Now).Hours & " ساعت و "& DateUtils.PeriodBetween(timestamp_cli,DateTime.Now).Minutes & " دقیقه و "
End Sub

'Sub NameShomareyeRoozeHafte(shomare As Int) As String
'	
'	Select shomare
'		Case 7
'			Return " شنبه "
'		Case 1
'			Return " یکشنبه "
'		Case 2
'			Return " دوشنبه "
'		Case 3
'			Return " سه شنبه "
'		Case 4
'			Return " چهارشنبه "
'		Case 5
'			Return " پنجشنبه "
'		Case 6
'			Return " جمعه "
'		Case Else
'			Return " امروز "
'	End Select
'	
'End Sub


Sub esmeRoozeHafte(timestamp As Long) As String
	
'	Log("Today Is: "&DateTime.GetDayOfWeek(DateTime.Now) &"   -    "&DateTime.Now &" - "&DateUtils.GetDayOfWeekName(timestamp))
'	Log("This Day Is: "&DateTime.GetDayOfWeek(timestamp)&"    -    "&timestamp &" - "&DateUtils.GetDayOfWeekName(timestamp))
	
	If timestamp == 0 Then timestamp = DateTime.Now
	
	Select DateTime.GetDayOfWeek(timestamp)
		Case 7
			Return " شنبه "
		Case 1
			Return " یکشنبه "
		Case 2
			Return " دوشنبه "
		Case 3
			Return " سه شنبه "
		Case 4
			Return " چهارشنبه "
		Case 5
			Return " پنجشنبه "
		Case 6
			Return " جمعه "
		Case Else
			Return " امروز "
	End Select
	
End Sub







'Sub RemoveShadows(Button1 As Button)
'	Try
'		If p.SdkVersion < 21 Then Return
'		Dim jo As Reflector
'		jo.Target = Button1
'		Sleep(0)
'		jo.RunMethod4("setElevation", Array As Object(0),Array As String("java.lang.float"))
'	Catch
'		Log("خطا در حذف سایه "&LastException)
'	End Try
'End Sub

'Sub AddBorder(bm As Bitmap,Bcolor As Int) As Bitmap
'	Dim nativeMe As JavaObject
'	Dim bm2 As Bitmap
'	Dim borderWidth2 As Int = 8
'	Dim borderColor2 As Int = Bcolor
'	nativeMe.InitializeContext
'	'iv.Bitmap = Null
'	'bm.Initialize(File.DirAssets,"stitch.jpg")
'	bm.Initialize3(bm)
'	borderColor2 = Bcolor
'	bm2 = nativeMe.RunMethod("addSquareBorder", Array(bm, borderWidth2, borderColor2))
'	Log(bm2.Height)
'	Return bm2
'End Sub


'Sub RegexReplace(Pattern As String, Text As String, Replacement As String) As String
'	Try
'		Dim m As Matcher
'		m = Regex.Matcher(Pattern, Text)
'		Dim r As Reflector
'		r.Target = m
'		Return r.RunMethod2("replaceAll", Replacement, "java.lang.String")
'	Catch
'		Log(LastException)
'		Return Text
'	End Try
'End Sub


'Sub PlainText (HTML As String) As String
'	HTML = RegexReplace("/<\s*br\/*>/gi", HTML, CRLF)
'	HTML = RegexReplace("/<\s*a.*href=" & QUOTE & "(.*?)" & QUOTE & ".*>(.*?)<\/a>/gi", HTML, " $2 (Link->$1) ")
'	HTML = RegexReplace("/<\s*\/*.+?>/ig", HTML, CRLF)
'	HTML = RegexReplace("/ {2,}/gi", HTML, " ")
'	HTML = RegexReplace("/\n+\s*/gi", HTML, CRLF & CRLF)
'	HTML = HTML.Replace("<p>", CRLF)
'	HTML = HTML.Replace("</p>", CRLF)
'	Return HTML
'End Sub


'Sub SetBitmapDensity(b As Bitmap) As Bitmap
'	Dim jo As JavaObject = b
'	Dim den As Int = Density * 160
'	jo.RunMethod("setDensity", Array(den))
'	Return b
'End Sub

'Sub DownloadImage(Link As String, iv As ImageView)
'   Dim j As HttpJob
'   j.Initialize("", Me)
'   j.Download(Link)
'   Wait For (j) JobDone(j As HttpJob)
'   If j.Success Then
'     iv.Bitmap = j.GetBitmap
'   End If
'   j.Release
'End Sub

Sub SetStatusBarColor(clr As Int)

	If p.SdkVersion >= 21 Then
		Dim JO As JavaObject
		JO.InitializeContext
		Dim window As JavaObject = JO.RunMethodJO("getWindow", Null)
		window.RunMethod("addFlags", Array (0x80000000))
		window.RunMethod("clearFlags", Array (0x04000000))
		window.RunMethod("setStatusBarColor", Array(clr))
	End If
	
	SetNavigationBarColor(clr)
	
End Sub

Sub SetNavigationBarColor(Clr As Int)

	Dim j As JavaObject
	J.InitializeStatic("android.os.Build$VERSION")
	If j.GetField("SDK_INT") > 20 Then
		J.InitializeContext.RunMethodJO("getWindow",Null).RunMethod ("setNavigationBarColor",Array(Clr))
	End If

End Sub

Sub FitCenterBitmap( Imv As ImageView , bmp As Bitmap )
'	dir1 As String , FileName As String
'	Private bmp As Bitmap = LoadBitmap( dir1 , FileName )
	Private cvs As Canvas
	cvs.Initialize(Imv)
	
	Dim rectDest As Rect
	Dim delta As Int
	If bmp.Width / bmp.Height > Imv.Width / Imv.Height Then
		delta = (Imv.Height - bmp.Height / bmp.Width * Imv.Width) / 2
		rectDest.Initialize(0, delta,Imv.Width, Imv.Height - delta)
	Else
		delta = (Imv.Width - bmp.Width / bmp.Height * Imv.Height) / 2
		rectDest.Initialize(delta, 0, Imv.Width - delta, Imv.Height)
	End If
	cvs.DrawBitmap(bmp, Null, rectDest)
	Imv.Invalidate
	
End Sub


Sub ValidateEmail(EmailAddress As String) As Boolean
	
	Dim MatchEmail As Matcher = Regex.Matcher("^(?i)[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])$", EmailAddress)
 
	If MatchEmail.Find = True Then
		Log(MatchEmail.Match)
		Return True
	Else
		Log("Oops, please double check your email address...")
		Return False
	End If
	
End Sub


Sub SetTextShadow(pView As View, pRadius As Float, pDx As Float, pDy As Float, pColor As Int)
	Dim ref As Reflector
	ref.Target = pView
	ref.RunMethod4("setShadowLayer", Array As Object(pRadius, pDx, pDy, pColor), Array As String("java.lang.float", "java.lang.float", "java.lang.float", "java.lang.int"))
End Sub


'Sub sendMail(sBody As String , sSubject As String , girande As String)
'
''	Try
''
''		Dim SMTP1 As SMTP
''		SMTP1.Initialize("smtp.gmail.com", 465, "rahyafteganevesal@gmail.com", "yaheydar" , "smtp")
''		SMTP1.UseSSL = True
''
''		SMTP1.To.Add(girande)
''		SMTP1.Subject = sSubject
''		SMTP1.body = sBody
''		SMTP1.Send
''
''
''	Catch
''	    ToastMessageShow("لطفا پیامک را امتحان کنید / در دسترس نیست",False)
''		If CheckConnection = False Then
''			ToastMessageShow("اینترنت خود را وصل کنید",True)
''		End If
''	End Try
'	
'	Dim Message As Email
'	Message.To.Add("saelozahra14@gmail.com")
'	Message.To.Add(girande)
'	Message.Subject = sSubject
'	Message.Body = sBody
'	StartActivity(Message.GetIntent)
'
'End Sub


Sub SetAnimation(InAnimation As String, OutAnimation As String)

	Dim r As Reflector
	Dim package As String
	Dim In, out As Int
	package = r.GetStaticField("anywheresoftware.b4a.BA", "packageName")
	In = r.GetStaticField(package & ".R$anim", InAnimation)
	out = r.GetStaticField(package & ".R$anim", OutAnimation)
	r.Target = r.GetActivity
	r.RunMethod4("overridePendingTransition", Array As Object(In, out), Array As String("java.lang.int", "java.lang.int"))

End Sub


Sub CheckConnection As Boolean
	
	If (p.GetDataState == "CONNECTED") Or (p.GetSettings ("wifi_on") == 1) Then
		Return True
	else If (p.GetDataState == "DISCONNECTED") Or (p.GetDataState == "SUSPENDED") Then
		Return False
	Else
		Return True
	End If
	
End Sub



'Sub beep(address As String)
'	Dim media As MediaPlayer
'	media.Initialize2("media")
'	media.Load(File.DirAssets,address)
'	media.SetVolume(0.2,0.2)
'	media.Play
'End Sub

Sub CheckSite As Boolean
	Dim sb As StringBuilder
	sb.Initialize
	p.Shell("ping -c 2 -W 10 -v "&SiteUrl.Replace("http://","").Replace("https://","").Replace("/",""), Null, sb, Null)
	If sb.Length = 0 Then
		Return False
	Else
		Return True
	End If
End Sub



Sub CSB(text As String) As CSBuilder
	Dim CS As CSBuilder
	CS.Initialize.Typeface(Font).Append(text).PopAll
	Return CS
End Sub

Sub CSBTitle(text As String) As CSBuilder
	Dim CS As CSBuilder
	CS.Initialize.Typeface(fontBold).Append(text).PopAll
	Return CS
End Sub

'Sub ChangeGooglemapStyle(StyleCode As String,Map As GoogleMap) As String
'	Dim jo As JavaObject = Map
'	Dim Style As JavaObject
'	Style.InitializeNewInstance("com.google.android.gms.maps.model.MapStyleOptions", Array(StyleCode))
'	Return jo.RunMethod("setMapStyle", Array(Style)) 'returns True if successful
'End Sub

Sub GetPathFromContentResult(UriString As String) As String
	If UriString.StartsWith("/") Then Return UriString 'If the user used a file manager to choose the image
	Dim Proj() As String
	Proj = Array As String("_data")
	Dim Cursor As Cursor
	Dim r As Reflector
	Dim Uri As Object
	Uri = r.RunStaticMethod("android.net.Uri", "parse", _
      Array As Object(UriString), _
      Array As String("java.lang.String"))
	r.Target = r.GetContext
	r.Target = r.RunMethod("getContentResolver")
	Cursor = r.RunMethod4("query", _
   Array As Object(Uri, Proj, Null, Null, Null), _
   Array As String("android.net.Uri", _
      "[Ljava.lang.String;", "java.lang.String", _
      "[Ljava.lang.String;", "java.lang.String"))
 
	Cursor.Position = 0
	Dim res As String
	res = Cursor.GetString("_data")
	Cursor.Close
	Return res
End Sub

'Sub SetColorStateList(Btn As Label,Pressed As Int,Enabled As Int)
'	Dim States(2,1) As Int
'	States(0,0) = 16842919    'Pressed
'	States(1,0) = 16842910    'Enabled
'	Dim CSL As JavaObject
'	CSL.InitializeNewInstance("android.content.res.ColorStateList",Array(States,Array As Int(Pressed, Enabled)))
'	Dim B1 As JavaObject = Btn
'	B1.RunMethod("setTextColor",Array As Object(CSL))
'End Sub

'Sub SearchableEditText(Edittext1 As EditText)
'	Dim JO As JavaObject = Edittext1
'	JO.RunMethod("setImeOptions",Array As Object(3))
'End Sub















'Sub SetNinePatchDrawable(Control As View, ImageName As String)
'	Dim r As Reflector
'	Dim package As String
'	Dim id As Int
'	package = r.GetStaticField("anywheresoftware.b4a.BA", "packageName")
'	id = r.GetStaticField(package & ".R$drawable", ImageName)
'	r.Target = r.GetContext
'	r.Target = r.RunMethod("getResources")
'	Control.Background = r.RunMethod2("getDrawable", id, "java.lang.int")
'End Sub


''PressedImage And DisabelImage can be empty string ("")
'Sub SetNinePatchButton(Btn As Button, DefaultImage As String, PressedImage As String, DisabelImage As String)
'	Dim r As Reflector
'	Dim package As String
'	Dim idDefault, iddisabel, idPressed As Int
'	package = r.GetStaticField("anywheresoftware.b4a.BA", "packageName")
'	idDefault = r.GetStaticField(package & ".R$drawable", DefaultImage)
'	If PressedImage <> "" Then idPressed = r.GetStaticField(package & ".R$drawable", PressedImage)
'	If DisabelImage <> "" Then iddisabel = r.GetStaticField(package & ".R$drawable", DisabelImage)
'	r.Target = r.GetContext
'	r.Target = r.RunMethod("getResources")
'	Dim sd As StateListDrawable
'	sd.Initialize
'	If PressedImage <> "" Then sd.AddState(sd.State_Pressed, r.RunMethod2("getDrawable", idPressed, "java.lang.int"))
'	If DisabelImage <> "" Then sd.AddState(sd.State_Disabled, r.RunMethod2("getDrawable", iddisabel, "java.lang.int"))
'	sd.AddCatchAllState( r.RunMethod2("getDrawable", idDefault, "java.lang.int"))
'	Btn.Background = sd
'End Sub


''DisabelImage can be empty string ("")
'Sub SetNinePatchcheckbox(chb As CheckBox, DefaultImage As String, CheckImage As String, UncheckImage As String, DisabelImage As String)
'	Dim r As Reflector
'	Dim package As String
'	Dim idDefault, idChecked, idUnChecked ,idDisabel As Int
'	package = r.GetStaticField("anywheresoftware.b4a.BA", "packageName")
'	idDefault = r.GetStaticField(package & ".R$drawable", DefaultImage)
'	idChecked = r.GetStaticField(package & ".R$drawable", CheckImage)
'	idUnChecked = r.GetStaticField(package & ".R$drawable", UncheckImage)
'	If DisabelImage <> "" Then idDisabel = r.GetStaticField(package & ".R$drawable", DisabelImage)
'	r.Target = r.GetContext
'	r.Target = r.RunMethod("getResources")
'	Dim sd As StateListDrawable
'	sd.Initialize
'	sd.AddState(sd.State_Checked, r.RunMethod2("getDrawable", idChecked, "java.lang.int"))
'	sd.AddState(sd.State_Unchecked, r.RunMethod2("getDrawable", idUnChecked, "java.lang.int"))
'	If DisabelImage <> "" Then sd.AddState(sd.State_Disabled, r.RunMethod2("getDrawable", idDisabel, "java.lang.int"))
'	sd.AddCatchAllState( r.RunMethod2("getDrawable", idDefault, "java.lang.int"))
'	chb.Background = sd
'End Sub


''DisabelImage can be empty string ("")
'Sub SetNinePatchEditText(EDT As EditText, DefaultImage As String, FocusedImage As String, DisabelImage As String)
'	Dim r As Reflector
'	Dim package As String
'	Dim idDefault, iddisabel, idFocused As Int
'	package = r.GetStaticField("anywheresoftware.b4a.BA", "packageName")
'	idDefault = r.GetStaticField(package & ".R$drawable", DefaultImage)
'	idFocused = r.GetStaticField(package & ".R$drawable", FocusedImage)
'	If DisabelImage <> "" Then iddisabel = r.GetStaticField(package & ".R$drawable", DisabelImage)
'	r.Target = r.GetContext
'	r.Target = r.RunMethod("getResources")
'	Dim sd As StateListDrawable
'	sd.Initialize
'	sd.AddState(sd.State_Focused, r.RunMethod2("getDrawable", idFocused, "java.lang.int"))
'	If DisabelImage <> "" Then sd.AddState(sd.State_Disabled, r.RunMethod2("getDrawable", iddisabel, "java.lang.int"))
'	sd.AddCatchAllState( r.RunMethod2("getDrawable", idDefault, "java.lang.int"))
'	EDT.Background = sd
'End Sub
'
''PressedImage, FocusedImage, CeckImage, UncheckImage, SelectedImage and DisabelImage can be empty string ("")
'Sub SetNinePatchControl(Control As View, DefaultImage As String, PressedImage As String, FocusedImage As String, CheckImage As String, UncheckImage As String, SelectedImage As String, DisabelImage As String)
'	Dim r As Reflector
'	Dim package As String
'	Dim idDefault, idDisabel, idFocused, idChecked, idUnChecked, idPressed, idSelected As Int
'	package = r.GetStaticField("anywheresoftware.b4a.BA", "packageName")
'	idDefault = r.GetStaticField(package & ".R$drawable", DefaultImage)
'	If PressedImage <> "" Then idPressed = r.GetStaticField(package & ".R$drawable", PressedImage)
'	If DisabelImage <> "" Then idDisabel = r.GetStaticField(package & ".R$drawable", DisabelImage)
'	If CheckImage <> "" Then idChecked = r.GetStaticField(package & ".R$drawable", CheckImage)
'	If UncheckImage <> "" Then idUnChecked = r.GetStaticField(package & ".R$drawable", UncheckImage)
'	If FocusedImage <> "" Then idFocused = r.GetStaticField(package & ".R$drawable", FocusedImage)
'	If SelectedImage <> "" Then idSelected = r.GetStaticField(package & ".R$drawable", SelectedImage)
'	r.Target = r.GetContext
'	r.Target = r.RunMethod("getResources")
'	Dim sd As StateListDrawable
'	sd.Initialize
'	If PressedImage <> "" Then sd.AddState(sd.State_Pressed, r.RunMethod2("getDrawable", idPressed, "java.lang.int"))
'	If DisabelImage <> "" Then sd.AddState(sd.State_Disabled, r.RunMethod2("getDrawable", idDisabel, "java.lang.int"))
'	If CheckImage <> "" Then sd.AddState(sd.State_Checked, r.RunMethod2("getDrawable", idChecked, "java.lang.int"))
'	If UncheckImage <> "" Then sd.AddState(sd.State_Unchecked, r.RunMethod2("getDrawable", idUnChecked, "java.lang.int"))
'	If FocusedImage <> "" Then sd.AddState(sd.State_Focused, r.RunMethod2("getDrawable", idFocused, "java.lang.int"))
'	If SelectedImage <> "" Then sd.AddState(sd.State_Selected, r.RunMethod2("getDrawable", idSelected, "java.lang.int"))
'	sd.AddCatchAllState( r.RunMethod2("getDrawable", idDefault, "java.lang.int"))
'	Control.Background = sd
'End Sub

'
''Change the size and color of a RadioButton graphic.
''Pass the required colors for the attributes, size should be a most to be the smallest side of the view.
'Sub SetRadioButtonDrawable(RBtn As RadioButton,CircleColor As Int,Size As Int,SelectedColor As Int,DisabledColor As Int,StrokeWidth As Int)
'	Log("Here")
'	Log(Size)
'	Dim Enabled,Selected,Disabled,DisabledSelected As BitmapDrawable
'	Dim EnabledJO,SelectedJO,DisabledJO,DisabledSelectedJO As JavaObject
'	Dim SLD As StateListDrawable
'	SLD.Initialize
'	'Changing the padding also determines how far away the text is from the drawing
'	Dim Padding As Int = Size / 100 * 50
'	Dim Radius As Int = (Size - Padding) / 2
'	Dim InnerPadding As Int = Max(1Dip,1)
'
'	Dim BMEnabled,BMSelected,BMDisabled,BMDisabledSelected As Bitmap
'	BMEnabled.InitializeMutable(Size,Size)
'	BMSelected.InitializeMutable(Size,Size)
'	BMDisabled.InitializeMutable(Size,Size)
'	BMDisabledSelected.InitializeMutable(Size,Size)
'	
'	'Draw Enabled State
'	Dim CNV As Canvas
'	CNV.Initialize2(BMEnabled)
'	CNV.DrawCircle(Radius + InnerPadding,Size / 2,Radius,CircleColor,False,StrokeWidth)
'	Enabled.Initialize(BMEnabled)
'	EnabledJO = Enabled
'	EnabledJO.RunMethod("setAntiAlias",Array As Object(True))
'	Enabled.Gravity = Gravity.left
'	
'	'Draw Selected state
'	Dim CNV1 As Canvas
'	CNV1.Initialize2(BMSelected)
'	CNV1.DrawCircle(Radius + InnerPadding,Size / 2,Radius,CircleColor,False,StrokeWidth)
'	'Draw the Selected state centered in the box
'	CNV1.DrawCircle(Radius + InnerPadding,Size / 2,(Radius - InnerPadding) / 2,SelectedColor,True,StrokeWidth)
'	Selected.Initialize(BMSelected)
'	SelectedJO = Selected
'	SelectedJO.RunMethod("setAntiAlias",Array As Object(True))
'	Selected.Gravity = Gravity.left
'	
'	'Draw disabled Selected State
'	Dim CNV2 As Canvas
'	CNV2.Initialize2(BMDisabledSelected)
'	CNV2.DrawCircle(Radius + InnerPadding,Size / 2,Radius,DisabledColor,False,StrokeWidth)
'	'Draw the Disabled Selected state centered in the box
'	CNV2.DrawCircle(Radius + InnerPadding,Size / 2,(Radius - InnerPadding) / 2,DisabledColor,True,StrokeWidth)
'	DisabledSelected.Initialize(BMDisabledSelected)
'	DisabledSelectedJO = DisabledSelected
'	DisabledSelectedJO.RunMethod("setAntiAlias",Array As Object(True))
'	DisabledSelected.Gravity = Gravity.left
'	
'	'Draw disabled State
'	Dim CNV3 As Canvas
'	CNV3.Initialize2(BMDisabled)
'	CNV3.DrawCircle(Radius + InnerPadding,Size / 2,Radius,DisabledColor,False,StrokeWidth)
'	Disabled.Initialize(BMDisabled)
'	DisabledJO = Disabled
'	DisabledJO.RunMethod("setAntiAlias",Array As Object(True))
'	Disabled.Gravity = Gravity.left
'
'	'Add To the StateList Drawable
'	SLD.AddState2(Array As Int(SLD.State_Disabled,SLD.State_Checked),DisabledSelected)
'	SLD.AddState(SLD.State_Disabled,Disabled)
'	SLD.AddState(SLD.State_Checked,Selected)
'	SLD.AddState(SLD.State_Enabled,Enabled)
'	SLD.AddCatchAllState(Enabled)
'	'Add SLD To the CheckBox
'	Dim JO As JavaObject = RBtn
'	JO.RunMethod("setButtonDrawable",Array As Object(SLD))
'	
'End Sub
'









'Sub Blur (bmp As B4XBitmap) As B4XBitmap
'	Dim n As Long = DateTime.Now
'	Dim bc As BitmapCreator
'	Dim ReduceScale As Int = 2
'	bc.Initialize(bmp.Width / ReduceScale / bmp.Scale, bmp.Height / ReduceScale / bmp.Scale)
'	bc.CopyPixelsFromBitmap(bmp)
'	Dim count As Int = 3
'	Dim clrs(3) As ARGBColor
'	Dim temp As ARGBColor
'	Dim m As Int
'	For steps = 1 To count
'		For y = 0 To bc.mHeight - 1
'			For x = 0 To 2
'				bc.GetARGB(x, y, clrs(x))
'			Next
'			SetAvg(bc, 1, y, clrs, temp)
'			m = 0
'			For x = 2 To bc.mWidth - 2
'				bc.GetARGB(x + 1, y, clrs(m))
'				m = (m + 1) Mod clrs.Length
'				SetAvg(bc, x, y, clrs, temp)
'			Next
'		Next
'		For x = 0 To bc.mWidth - 1
'			For y = 0 To 2
'				bc.GetARGB(x, y, clrs(y))
'			Next
'			SetAvg(bc, x, 1, clrs, temp)
'			m = 0
'			For y = 2 To bc.mHeight - 2
'				bc.GetARGB(x, y + 1, clrs(m))
'				m = (m + 1) Mod clrs.Length
'				SetAvg(bc, x, y, clrs, temp)
'			Next
'		Next
'	Next
'	Log(DateTime.Now - n)
'	Return bc.Bitmap
'End Sub

Private Sub SetAvg(bc As BitmapCreator, x As Int, y As Int, clrs() As ARGBColor, temp As ARGBColor)
	temp.Initialize
	For Each c As ARGBColor In clrs
		temp.r = temp.r + c.r
		temp.g = temp.g + c.g
		temp.b = temp.b + c.b
	Next
	temp.a = 255
	temp.r = temp.r / clrs.Length
	temp.g = temp.g / clrs.Length
	temp.b = temp.b / clrs.Length
	bc.SetARGB(x, y, temp)
End Sub

'' تعیین رنگ و فاصله بین آیتم های لیست ویو
'Sub SetLVDivider(MyLV As ListView, MyColor As Int, Height As Int)
'	Dim Re As Reflector
'	Re.Target = MyLV
'	Dim LVCD As ColorDrawable
'	LVCD.Initialize(MyColor, 0)
'	Re.RunMethod4("setDivider", Array As Object(LVCD), Array As String("android.graphics.drawable.Drawable"))
'	Re.RunMethod2("setDividerHeight", Height, "java.lang.int")
'End Sub

Sub SetErrorEditText(ET As EditText,text As String)
	Dim j As JavaObject
	j=ET
	j.RunMethod("setError",Array(text))
End Sub

Sub SetElevation (b As View ,f As Float)
	Dim sdk As Phone
	Dim JO As JavaObject = b
	If sdk.SdkVersion > 20 Then
		JO.RunMethod("setElevation",Array As Object(f))
		JO.RunMethod("setStateListAnimator", Array(Null))
	End If
End Sub
	
#IgnoreWarnings:2
Sub GetViewByTag(Parent As Panel,Tag As String) As View
	For Each v As View In Parent.GetAllViewsRecursive
		If v.Tag == Tag Then Return v
	Next
'	Return Null
End Sub