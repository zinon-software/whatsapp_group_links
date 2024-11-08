import 'package:cloud_firestore/cloud_firestore.dart';

String handleFirebaseException(FirebaseException e) {
  switch (e.code) {
    case 'invalid-email':
      return 'البريد الإلكتروني غير صالح';
    case 'weak-password':
      return 'كلمة المرور ضعيفة';
    case 'user-not-found':
      return 'لا يوجد مستخدم بهذا البريد الإلكتروني';
    case 'wrong-password':
      return 'كلمة المرور غير صحيحة';
    case 'too-many-requests':
      return 'تم تجاوز الحد الأقصى لعدد الطلبات';
    // Cloud Firestore errors
    case 'permission-denied':
      return 'لا يملك المستخدم الإذن المطلوب';
    case 'document-not-found':
      return 'لم يتم العثور على المستند';
    case 'field-not-found':
      return 'لم يتم العثور على الحقل';
    case 'invalid-document-id':
      return 'معرّف المستند غير صالح';
    case 'invalid-field-path':
      return 'مسار الحقل غير صالح';
    case 'invalid-value':
      return 'القيمة غير صالحة';
    case 'duplicate-field-name':
      return 'اسم الحقل مكرر';
    case 'transaction-failed':
      return 'فشل المعاملة';
    // [cloud_firestore/unavailable] error
    case 'cloud_firestore/unavailable':
      return 'خدمة Cloud Firestore غير متوفرة حاليًا. هذا هو على الأرجح حالة مؤقتة وقد يتم تصحيحها عن طريق إعادة المحاولة مع التراجع.';
    default:
      return 'رمز الخطأ: ${e.code}, الرسالة: ${e.message}';
  }
}

String handleException(Object e) {
  if (e is FirebaseException) {
    return handleFirebaseException(e);
  } else {
    return 'حدث خطأ ما: ${e.toString()}';
  }
}