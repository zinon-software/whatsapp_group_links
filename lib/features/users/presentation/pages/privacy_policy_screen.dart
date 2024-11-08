import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("سياسة الخصوصية"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "الخصوصية وبيان سريّة المعلومات",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "نقدر مخاوفكم واهتمامكم بشأن خصوصية بياناتكم على شبكة الإنترنت. "
              "لقد تم إعداد هذه السياسة لمساعدتكم في تفهم طبيعة البيانات التي نقوم بتجميعها منكم عند زيارتكم لتطبيقنا على شبكة الانترنت وكيفية تعاملنا مع هذه البيانات الشخصية.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "التصفح",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "لم نقم بتصميم هذا التطبيق من أجل تجميع بياناتك الشخصية من الجهاز الخاص بك أثناء تصفحك لهذا التطبيق، "
              "ولا نقوم بجمع أي معلومات، التطبيق يعمل بدون إنترنت ولكنه يقوم بإرسال إشعارات للمستخدمين بخصوص التحديثات.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "عنوان بروتوكول شبكة الإنترنت (IP)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "في أي وقت تزور فيه أي تطبيق مرتبط بالإنترنت بما فيها هذا التطبيق، سيقوم السيرفر المضيف بتسجيل عنوان بروتوكول شبكة الإنترنت (IP) الخاص بك، "
              "تاريخ ووقت الزيارة ونوع متصفح الإنترنت الذي تستخدمه؛ علماً أن تطبيقنا مرتبط بسيرفر Firebase المقدم من شركة Google والذي يُعد آمناً عالميًا لتزويد المستخدمين بأحدث التحديثات.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "الروابط بالمواقع الأخرى على شبكة الإنترنت",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "يشتمل تطبيقنا على إعلانات من مواقع Google AdSense ولا نعتبر مسؤولين عن أساليب تجميع البيانات من قبل مواقع Google AdSense، "
              "يمكنك الاطلاع على سياسات السرية والمحتويات الخاصة بتلك المواقع التي يتم الدخول إليها من خلال أي رابط ضمن إعلانات Google AdSense. "
              "يوجد رابط مواقع على شبكة الإنترنت داخل التطبيق ونحن نضمن هذا الموقع بحيث يمكنك الانتقال إلى ذلك الموقع بمحض إرادتك.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "عند الاتصال بنا",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "سيتم استخدام البيانات التي يتم تقديمها من قبلك في الرد على كافة استفساراتك، ملاحظاتك، أو طلباتك من خلال الإيميل. "
              "ونتعهد بعدم الإزعاج بإرسال أي إعلانات أو منشورات.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "إفشاء المعلومات لأي طرف ثالث",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "نحن لا نقوم بالاحتفاظ بأي معلومات للمستخدمين أين كانت، لذا لا توجد أي معلومات للمتاجرة بها، وإن وجدت فنحن نضمن حقوق مستخدمي التطبيق "
              "ولا يمكن المتاجرة في عملائنا الكرام.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "التعديلات على سياسة سرية وخصوصية المعلومات",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "نحتفظ بالحق في تعديل بنود وشروط سياسة سرية وخصوصية المعلومات إن لزم الأمر ومتى كان ذلك ملائماً. "
              "سيتم تنفيذ التعديلات هنا أو على صفحة سياسة الخصوصية الرئيسية وسيتم بصفة مستمرة إخطارك بالبيانات التي حصلنا عليها، وكيف سنستخدمها، والجهة التي سنقوم بتزويدها بهذه البيانات.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "الاتصال بنا",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "يمكنكم الاتصال بنا عند الحاجة من خلال الدخول إلى صفحة المبرمج وإرسال بريد إلكتروني إلى sawh2030@gmail.com",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "أخيراً",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "إن مخاوفك واهتمامك بشأن سرية وخصوصية البيانات تعتبر مسألة في غاية الأهمية بالنسبة لنا. "
              "نحن نأمل أن يتم تحقيق ذلك من خلال هذه السياسة.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
