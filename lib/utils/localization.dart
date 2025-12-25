import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
  
  static const LocalizationsDelegate<AppLocalizations> delegate = AppLocalizationsDelegate();
  
  static final Map<String, Map<String, String>> _localizedStrings = {
    'en': {
      // Authentication
      'welcome_back': 'Welcome Back',
      'sign_in_continue': 'Sign in to continue your learning journey',
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'full_name': 'Full Name',
      'phone_number': 'Phone Number',
      'sign_in': 'Sign In',
      'create_account': 'Create Account',
      'or': 'or',
      'continue_with_google': 'Continue with Google',
      'select_role': 'Select Role',
      'student': 'Student',
      'tutor': 'Tutor',
      'gender': 'Gender',
      'male': 'Male',
      'female': 'Female',
      'accept_terms': 'I accept the Terms of Service and Privacy Policy',
      'enter_otp': 'Enter OTP',
      'email_required': 'Email is required',
      'invalid_email': 'Please enter a valid email',
      'password_required': 'Password is required',
      
      // Dashboard
      'dashboard': 'Dashboard',
      'search_tutors': 'Search for tutors...',
      'all_tutors': 'All Tutors',
      'favorites': 'Favorites',
      'no_tutors_found': 'No tutors found',
      'try_different_search': 'Try adjusting your search or filters',
      'no_favorites_yet': 'No favorites yet',
      'add_tutors_to_favorites': 'Add tutors to see them here',
      'filter_tutors': 'Filter Tutors',
      'subjects': 'Subjects',
      'grade_levels': 'Grade Levels',
      'city': 'City',
      'max_hourly_rate': 'Maximum Hourly Rate',
      'sar': 'SAR',
      'clear_all': 'Clear All',
      'apply_filters': 'Apply Filters',
      'select_city': 'Select City',
      'notifications': 'Notifications',
      'close': 'Close',
      'profile': 'Profile',
      'settings': 'Settings',
      'logout': 'Logout',
      
      // Tutor Profile
      'years_experience': 'Years\nExperience',
      'reviews': 'Reviews',
      'sar_hour': 'SAR\n/Hour',
      'intro_video': 'Introduction Video',
      'about': 'About',
      'subjects_taught': 'Subjects Taught',
      'teaching_type': 'Teaching Type',
      'online': 'Online',
      'in_person': 'In Person',
      'both': 'Both',
      'excellent_rating': 'Excellent Rating',
      'added_to_favorites': 'Added to favorites',
      'removed_from_favorites': 'Removed from favorites',
      'start_chat': 'Start Chat',
      'report': 'Report',
      
      // Chat
      'type_message': 'Type a message...',
      'lesson_completed': 'Lesson Completed!',
      'please_rate_tutor': 'Please rate your experience with this tutor',
      'submit_rating': 'Submit Rating',
      'mark_lesson_complete': 'Mark Lesson as Complete',
      'mark_lesson_complete_confirm': 'Are you sure you want to mark this lesson as completed?',
      'lesson_marked_complete': 'Lesson marked as completed',
      'confirm': 'Confirm',
      'cancel': 'Cancel',
      'rating_submitted': 'Rating submitted successfully',
      'block_user': 'Block User',
      'block_user_confirm': 'Are you sure you want to block this user? This will disable chat.',
      'user_blocked': 'User has been blocked',
      'block': 'Block',
      'blocked_by_user': 'This conversation has been blocked by the other user',
      'conversation_blocked': 'This conversation has been blocked',
      'select_attachment': 'Select Attachment',
      'camera': 'Camera',
      'gallery': 'Gallery',
      'file': 'File',
      
      // Complaint
      'report_user': 'Report User',
      'report_inappropriate_behavior': 'Report Inappropriate Behavior',
      'help_us_maintain_safe_environment': 'Help us maintain a safe learning environment for everyone',
      'reason_optional': 'Reason (Optional)',
      'select_reason': 'Select a reason',
      'inappropriate_behavior': 'Inappropriate Behavior',
      'spam': 'Spam',
      'false_information': 'False Information',
      'harassment': 'Harassment',
      'other': 'Other',
      'additional_details_optional': 'Additional Details (Optional)',
      'describe_issue': 'Describe the issue in detail...',
      'attachments_optional': 'Attachments (Optional)',
      'upload_screenshots': 'Upload screenshots or evidence (images only)',
      'attached_files': 'Attached Files',
      'submit_complaint': 'Submit Complaint',
      'complaint_will_be_reviewed': 'Your complaint will be reviewed by our admin team within 24-48 hours.',
      'complaint_submitted_successfully': 'Complaint submitted successfully',
      
      // Tutor Dashboard
      'overview': 'Overview',
      'profile_views': 'Profile\nViews',
      'rating': 'Rating',
      'sessions': 'Sessions',
      'students': 'Students',
      'subscription_active': 'Subscription Active',
      'expires_in_5_days': 'Expires in 5 days',
      'renew': 'Renew',
      'admin_notifications': 'Admin Notifications',
      'interested_students': 'Interested Students',
      'view_all': 'View All',
      'session_history': 'Session History',
    },
    'ar': {
      // Authentication
      'welcome_back': 'مرحباً بعودتك',
      'sign_in_continue': 'سجل دخولك لمتابعة رحلة التعلم',
      'login': 'تسجيل الدخول',
      'register': 'إنشاء حساب',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'full_name': 'الاسم الكامل',
      'phone_number': 'رقم الهاتف',
      'sign_in': 'تسجيل الدخول',
      'create_account': 'إنشاء حساب',
      'or': 'أو',
      'continue_with_google': 'المتابعة مع جوجل',
      'select_role': 'اختر الدور',
      'student': 'طالب',
      'tutor': 'مدرس',
      'gender': 'الجنس',
      'male': 'ذكر',
      'female': 'أنثى',
      'accept_terms': 'أوافق على شروط الخدمة وسياسة الخصوصية',
      'enter_otp': 'أدخل رمز التحقق',
      'email_required': 'البريد الإلكتروني مطلوب',
      'invalid_email': 'يرجى إدخال بريد إلكتروني صحيح',
      'password_required': 'كلمة المرور مطلوبة',
      
      // Dashboard
      'dashboard': 'الرئيسية',
      'search_tutors': 'البحث عن مدرسين...',
      'all_tutors': 'جميع المدرسين',
      'favorites': 'المفضلة',
      'no_tutors_found': 'لم يتم العثور على مدرسين',
      'try_different_search': 'جرب تعديل البحث أو الفلاتر',
      'no_favorites_yet': 'لا توجد مفضلات بعد',
      'add_tutors_to_favorites': 'أضف مدرسين لرؤيتهم هنا',
      'filter_tutors': 'تصفية المدرسين',
      'subjects': 'المواد',
      'grade_levels': 'المراحل الدراسية',
      'city': 'المدينة',
      'max_hourly_rate': 'أقصى أجر بالساعة',
      'sar': 'ريال',
      'clear_all': 'مسح الكل',
      'apply_filters': 'تطبيق الفلاتر',
      'select_city': 'اختر المدينة',
      'notifications': 'الإشعارات',
      'close': 'إغلاق',
      'profile': 'الملف الشخصي',
      'settings': 'الإعدادات',
      'logout': 'تسجيل الخروج',
      
      // Tutor Profile
      'years_experience': 'سنوات\nالخبرة',
      'reviews': 'تقييمات',
      'sar_hour': 'ريال\n/ساعة',
      'intro_video': 'فيديو تعريفي',
      'about': 'حول',
      'subjects_taught': 'المواد التي يدرسها',
      'teaching_type': 'نوع التدريس',
      'online': 'عن بُعد',
      'in_person': 'حضوري',
      'both': 'كلاهما',
      'excellent_rating': 'تقييم ممتاز',
      'added_to_favorites': 'تم إضافة للمفضلة',
      'removed_from_favorites': 'تم الحذف من المفضلة',
      'start_chat': 'بدء المحادثة',
      'report': 'إبلاغ',
      
      // Chat
      'type_message': 'اكتب رسالة...',
      'lesson_completed': 'تم إكمال الدرس!',
      'please_rate_tutor': 'يرجى تقييم تجربتك مع هذا المدرس',
      'submit_rating': 'إرسال التقييم',
      'mark_lesson_complete': 'تحديد الدرس كمكتمل',
      'mark_lesson_complete_confirm': 'هل أنت متأكد من أنك تريد تحديد هذا الدرس كمكتمل؟',
      'lesson_marked_complete': 'تم تحديد الدرس كمكتمل',
      'confirm': 'تأكيد',
      'cancel': 'إلغاء',
      'rating_submitted': 'تم إرسال التقييم بنجاح',
      'block_user': 'حظر المستخدم',
      'block_user_confirm': 'هل أنت متأكد من أنك تريد حظر هذا المستخدم؟ سيتم تعطيل المحادثة.',
      'user_blocked': 'تم حظر المستخدم',
      'block': 'حظر',
      'blocked_by_user': 'تم حظر هذه المحادثة من قبل المستخدم الآخر',
      'conversation_blocked': 'تم حظر هذه المحادثة',
      'select_attachment': 'اختر مرفق',
      'camera': 'الكاميرا',
      'gallery': 'المعرض',
      'file': 'ملف',
      
      // Complaint
      'report_user': 'إبلاغ عن المستخدم',
      'report_inappropriate_behavior': 'إبلاغ عن سلوك غير لائق',
      'help_us_maintain_safe_environment': 'ساعدنا في الحفاظ على بيئة تعليمية آمنة للجميع',
      'reason_optional': 'السبب (اختياري)',
      'select_reason': 'اختر سبباً',
      'inappropriate_behavior': 'سلوك غير لائق',
      'spam': 'رسائل غير مرغوب فيها',
      'false_information': 'معلومات خاطئة',
      'harassment': 'تحرش',
      'other': 'أخرى',
      'additional_details_optional': 'تفاصيل إضافية (اختياري)',
      'describe_issue': 'وصف المشكلة بالتفصيل...',
      'attachments_optional': 'مرفقات (اختياري)',
      'upload_screenshots': 'تحميل لقطات شاشة أو أدلة (صور فقط)',
      'attached_files': 'الملفات المرفقة',
      'submit_complaint': 'إرسال الشكوى',
      'complaint_will_be_reviewed': 'ستتم مراجعة شكواك من قبل فريق الإدارة خلال 24-48 ساعة.',
      'complaint_submitted_successfully': 'تم إرسال الشكوى بنجاح',
      
      // Tutor Dashboard
      'overview': 'نظرة عامة',
      'profile_views': 'مشاهدات\nالملف الشخصي',
      'rating': 'التقييم',
      'sessions': 'الجلسات',
      'students': 'الطلاب',
      'subscription_active': 'الاشتراك نشط',
      'expires_in_5_days': 'ينتهي خلال 5 أيام',
      'renew': 'تجديد',
      'admin_notifications': 'إشعارات الإدارة',
      'interested_students': 'الطلاب المهتمون',
      'view_all': 'عرض الكل',
      'session_history': 'سجل الجلسات',
    },
  };
  
  String translate(String key) {
    return _localizedStrings[locale.languageCode]?[key] ?? key;
  }
  
  String get languageCode => locale.languageCode;
  
  bool get isRTL => locale.languageCode == 'ar';
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();
  
  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }
  
  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }
  
  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}