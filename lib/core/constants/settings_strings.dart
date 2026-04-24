abstract class SettingsStrings {
  static String _languageCode = 'en';

  static void setLanguageCode(String code) {
    _languageCode = code.toLowerCase() == 'ar' ? 'ar' : 'en';
  }

  static String _t(String en, String ar) => _languageCode == 'ar' ? ar : en;

  static String get settingsTitle => _t('Settings', 'الإعدادات');
  static String get medicalProfileTitle => _t('Medical Profile', 'الملف الطبي');
  static String get medicalProfileSubtitle =>
      _t('Prescriptions | Medicine | Notes', 'الوصفات | الأدوية | الملاحظات');
  static String get languageTitle => _t('Language', 'اللغة');
  static String get supportTitle => _t('Support', 'الدعم');
  static String get supportSubtitle => _t('24/7 Support', 'دعم 24/7');
  static String get supportComingSoon =>
      _t('Support center is coming soon.', 'مركز الدعم قريبا.');
  static String get themeTitle => _t('Theme', 'المظهر');
  static String get termsPrivacyTitle =>
      _t('Terms & Privacy', 'الشروط والخصوصية');
  static String get contactUsTitle => _t('Contact us', 'تواصل معنا');
  static String get reportsTitle => _t('Reports', 'التقارير');

  static String get selectLanguageTitle => _t('Select language', 'اختر اللغة');
  static String get cancel => _t('Cancel', 'إلغاء');
  static String get select => _t('Select', 'اختيار');
  static String get english => _t('English', 'الإنجليزية');
  static String get arabic => _t('Arabic', 'العربية');

  static String get medicalTabPrescriptions => _t('Prescriptions', 'الوصفات');
  static String get medicalTabMedicine => _t('Medicine', 'الأدوية');
  static String get medicalTabNotes => _t('Notes', 'الملاحظات');
  static String get noPrescriptions =>
      _t('No prescriptions yet.', 'لا توجد وصفات بعد.');
  static String get noPrescriptionImage =>
      _t('No prescription image available.', 'لا توجد صورة وصفة متاحة.');
  static String get noMedicines =>
      _t('No medicine records yet.', 'لا توجد سجلات أدوية بعد.');
  static String get noNotes => _t('No notes yet.', 'لا توجد ملاحظات بعد.');
  static String get oral => _t('ORAL', 'فموي');
  static String get prescriptionNumberLabel =>
      _t('Prescription No:', 'رقم الوصفة:');
  static String get prescriptionNameLabel =>
      _t('Prescription Name:', 'اسم الوصفة:');
  static String get dosageLabel => _t('Dosage:', 'الجرعة:');
  static String get scheduleLabel => _t('Schedule:', 'الجدول:');
  static String get refillLabel => _t('Refill:', 'إعادة التعبئة:');
  static String get nextRefillLabel =>
      _t('Next refill:', 'إعادة التعبئة القادمة:');
  static String get doctorLabel => _t('Doctor:', 'الطبيب:');
  static String get capturedAtLabel => _t('Captured:', 'تاريخ الالتقاط:');
  static String get viewDocument => _t('View Image', 'عرض الصورة');
  static String get downloadDocument => _t('Download Image', 'تنزيل الصورة');
  static String get shareWithPharmacist => _t('Share Image', 'مشاركة الصورة');
  static String get prescriptionDocument => _t('Prescription', 'وصفة');
  static String get sessionReportDocument => _t('Session Report', 'تقرير جلسة');
  static String get sharedWithPharmacistSuccess => _t(
    'Prescription image shared successfully.',
    'تمت مشاركة صورة الوصفة بنجاح.',
  );
  static String get imageDownloadedSuccess => _t(
    'Prescription image downloaded successfully.',
    'تم تنزيل صورة الوصفة بنجاح.',
  );
  static String get imageOperationFailed => _t(
    'Could not complete image operation. Please try again.',
    'تعذر إكمال عملية الصورة. يرجى المحاولة مرة أخرى.',
  );
  static String get noImageToShare => _t(
    'No image attached to this prescription yet.',
    'لا توجد صورة مرفقة بهذه الوصفة بعد.',
  );
  static String get totalLabel => _t('Total:', 'الإجمالي:');
  static String get activeMedicinesLabel =>
      _t('Active medicines:', 'الأدوية النشطة:');
  static String get totalNotesLabel => _t('Total notes:', 'إجمالي الملاحظات:');
  static String get editNote => _t('Edit', 'تعديل');
  static String get shareNote => _t('Share', 'مشاركة');
  static String get editMedicalNoteTitle =>
      _t('Edit Medical Note', 'تعديل الملاحظة الطبية');
  static String get noteTitleLabel => _t('Note title', 'عنوان الملاحظة');
  static String get noteContentLabel => _t('Note details', 'تفاصيل الملاحظة');
  static String get saveChanges => _t('Save Changes', 'حفظ التغييرات');
  static String get shareWithDoctorTitle =>
      _t('Share with Doctor', 'المشاركة مع الطبيب');
  static String get chooseDoctorLabel => _t('Choose doctor', 'اختر الطبيب');
  static String get chooseDoctorHint => _t('Select a doctor', 'اختر طبيبا');
  static String get shareNow => _t('Share Now', 'شارك الآن');
  static String get noteUpdatedSuccess =>
      _t('Note updated successfully.', 'تم تحديث الملاحظة بنجاح.');
  static String get selectDoctorError =>
      _t('Please select a doctor.', 'يرجى اختيار طبيب.');

  static String get profileTitle => _t('Profile', 'الملف الشخصي');
  static String get editProfileTitle =>
      _t('Edit Profile', 'تعديل الملف الشخصي');
  static String get fullNameTitle => _t('Full Name', 'الاسم الكامل');
  static String get emailTitleProfile =>
      _t('Email Address', 'البريد الإلكتروني');
  static String get phoneTitleProfile => _t('Phone Number', 'رقم الهاتف');
  static String get birthDateTitle => _t('Birth Date', 'تاريخ الميلاد');
  static String get genderTitle => _t('Gender', 'الجنس');
  static String get passwordTitle => _t('Password', 'كلمة المرور');
  static String get saveProfileChanges => _t('Save Changes', 'حفظ التغييرات');
  static String get changeEmailTitle =>
      _t('Change Email', 'تغيير البريد الإلكتروني');
  static String get addNumberTitle => _t('Add Number', 'إضافة رقم');
  static String get deleteAccountTitle => _t('Delete Account', 'حذف الحساب');
  static String get profileUpdatedSuccess =>
      _t('Profile updated successfully.', 'تم تحديث الملف الشخصي بنجاح.');
  static String get emailVerificationRequired => _t(
    'Verify the new email before saving it.',
    'تحقق من البريد الجديد قبل الحفظ.',
  );
  static String get updateProfileHint => _t(
    'Edit the profile fields below. Email changes will be verified by OTP.',
    'قم بتعديل بيانات الملف أدناه. سيتم التحقق من تغيير البريد عبر رمز OTP.',
  );
  static String get verificationCodeSent =>
      _t('Verification code sent.', 'تم إرسال رمز التحقق.');
  static String get emailUpdatedSuccess =>
      _t('Email updated successfully.', 'تم تحديث البريد الإلكتروني بنجاح.');
  static String get verifyNewEmailTitle =>
      _t('Verify New Email', 'تحقق من البريد الإلكتروني الجديد');
  static String get resendCode => _t('Resend code', 'إعادة إرسال الرمز');
  static String get verify => _t('Verify', 'تحقق');

  static String get changePasswordTitle =>
      _t('Change Password', 'تغيير كلمة المرور');
  static String get oldPasswordLabel =>
      _t('Old Password', 'كلمة المرور القديمة');
  static String get oldPasswordHint =>
      _t('Enter your current password', 'أدخل كلمة المرور الحالية');
  static String get newPasswordLabel =>
      _t('New Password', 'كلمة المرور الجديدة');
  static String get newPasswordHint =>
      _t('Enter your new password', 'أدخل كلمة المرور الجديدة');
  static String get confirmPasswordLabel =>
      _t('Confirm Password', 'تأكيد كلمة المرور');
  static String get confirmPasswordHint =>
      _t('Confirm your new password', 'أكد كلمة المرور الجديدة');
  static String get passwordChanged =>
      _t('Password changed successfully.', 'تم تغيير كلمة المرور بنجاح.');
  static String get passwordMismatch =>
      _t('Passwords do not match.', 'كلمتا المرور غير متطابقتين.');
  static String get invalidOldPassword =>
      _t('Current password is incorrect.', 'كلمة المرور الحالية غير صحيحة.');
  static String get verifyOldEmailTitle =>
      _t('Verify Current Email', 'تحقق من البريد الحالي');
  static String get verifyOldEmailDesc => _t(
    'We will send a verification code to your current email address.',
    'سنرسل رمز تحقق إلى عنوان بريدك الإلكتروني الحالي.',
  );
  static String get newEmailVerificationDesc => _t(
    'A verification code will be sent to your new email address.',
    'سيتم إرسال رمز تحقق إلى عنوان بريدك الإلكتروني الجديد.',
  );
  static String get deleteAccountWarning => _t(
    'Are you sure you want to delete your account? This action cannot be undone.',
    'هل أنت متأكد من حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.',
  );
  static String get deleteAccountConfirm => _t(
    'Type "DELETE" to confirm account deletion.',
    'اكتب "DELETE" لتأكيد حذف الحساب.',
  );
  static String get deleteConfirmationText => 'DELETE';
  static String get accountDeletedSuccess =>
      _t('Your account has been deleted successfully.', 'تم حذف حسابك بنجاح.');
  static String get forgotPasswordTitle =>
      _t('Reset Password', 'إعادة تعيين كلمة المرور');
  static String get forgotPasswordDesc => _t(
    'Enter your email address and we will send you a code to reset your password.',
    'أدخل بريدك الإلكتروني وسنرسل لك رمزا لإعادة تعيين كلمة المرور.',
  );
  static String get sendCode => _t('Send Code', 'إرسال الرمز');
  static String get resetPassword =>
      _t('Reset Password', 'إعادة تعيين كلمة المرور');

  static String get privacyTermsTitle =>
      _t('Privacy & Terms', 'الخصوصية والشروط');
  static String get privacyPolicyTitle =>
      _t('Privacy Policy', 'سياسة الخصوصية');
  static String get termsOfServiceTitle =>
      _t('Terms of Service', 'شروط الخدمة');
  static String get cookiePolicyTitle =>
      _t('Cookie Policy', 'سياسة ملفات الارتباط');
  static String get privacyLastUpdated =>
      _t('Last updated: April 2026', 'آخر تحديث: أبريل 2026');
  static String get privacyContactHint => _t(
    'For questions about our privacy practices or terms, please contact us.',
    'للأسئلة حول ممارسات الخصوصية أو الشروط، يرجى التواصل معنا.',
  );

  static String get contactScreenTitle => _t('Contact Us', 'اتصل بنا');
  static String get getInTouchTitle => _t('Get in Touch', 'ابق على تواصل');
  static String get getInTouchSubtitle => _t(
    'We\'d love to hear from you. Send us a message and we\'ll respond as soon as possible.',
    'يسعدنا سماعك. أرسل لنا رسالة وسنرد عليك بأسرع وقت.',
  );
  static String get sendMessageSectionTitle =>
      _t('Send us a Message', 'أرسل لنا رسالة');
  static String get sendMessageButton => _t('Send Message', 'إرسال الرسالة');
  static String get emailTitle => _t('Email', 'البريد الإلكتروني');
  static String get phoneTitle => _t('Phone', 'الهاتف');
  static String get officeTitle => _t('Office', 'المكتب');
  static String get hoursTitle => _t('Hours', 'ساعات العمل');
  static String get fullNameLabel => _t('Full Name', 'الاسم الكامل');
  static String get fullNameHint =>
      _t('Enter your full name', 'أدخل اسمك الكامل');
  static String get emailAddressLabel =>
      _t('Email Address', 'عنوان البريد الإلكتروني');
  static String get emailAddressHint =>
      _t('your.email@example.com', 'example@email.com');
  static String get messageLabel => _t('Message', 'الرسالة');
  static String get messageHint =>
      _t('Tell us how we can help...', 'أخبرنا كيف يمكننا مساعدتك...');
  static String get fillAllFieldsError =>
      _t('Please fill in all fields', 'يرجى تعبئة جميع الحقول');
  static String get invalidEmailError =>
      _t('Please enter a valid email address', 'يرجى إدخال بريد إلكتروني صالح');
  static String get messageSentSuccess =>
      _t('Message sent successfully!', 'تم إرسال الرسالة بنجاح!');
}
