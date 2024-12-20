import 'package:flutter/material.dart';

class SelectedCountryWidget extends StatelessWidget {
  const SelectedCountryWidget({
    super.key,
    required this.onChanged,
    required this.lang,
    this.selectedCountryName,
  });

  final Function(String) onChanged;
  final String lang;
  final String? selectedCountryName;

  @override
  Widget build(BuildContext context) {
    // تأكد من أن selectedCountry هو قيمة صالحة
    Country? selectedValue = countries
        .where(
          (c) => c.getName(lang) == selectedCountryName,
        )
        .firstOrNull;

    return DropdownButtonFormField<String>(
      hint: const Text('اختر دولة'),
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.all(16),
      ),
      value: selectedValue?.code,
      onChanged: (String? selectedCountryCode) {
        if (selectedCountryCode != null) {
          final country =
              countries.firstWhere((c) => c.code == selectedCountryCode);
          onChanged(country.getName(lang));
        }
      },
      items: countries.map(
        (country) {
          return DropdownMenuItem<String>(
            value: country.code,
            child: Text(country.getName(lang)),
          );
        },
      ).toList(),
      validator: (value) {
        if (value == null) {
          return 'يرجى اختيار دولة';
        }
        return null;
      },
    );
  }
}

class Country {
  final String code;
  final String nameAr;
  final String nameEn;

  Country({
    required this.code,
    required this.nameAr,
    required this.nameEn,
  });

  String getName(String lang) {
    return lang == 'ar' ? nameAr : nameEn;
  }
}

// تعريف قائمة الدول باستخدام كائنات Country
List<Country> countries = countriesJson.entries.map((entry) {
  final code = entry.key;
  final nameAr = entry.value['ar']!;
  final nameEn = entry.value['en']!;

  return Country(code: code, nameAr: nameAr, nameEn: nameEn);
}).toList();

Map<String, Map<String, String>> countriesJson = {
  'AF': {'ar': 'أفغانستان', 'en': 'Afghanistan'},
  'AL': {'ar': 'ألبانيا', 'en': 'Albania'},
  'DZ': {'ar': 'الجزائر', 'en': 'Algeria'},
  'AD': {'ar': 'أندورا', 'en': 'Andorra'},
  'AO': {'ar': 'أنغولا', 'en': 'Angola'},
  'AG': {'ar': 'أنتيغوا وباربودا', 'en': 'Antigua and Barbuda'},
  'AR': {'ar': 'الأرجنتين', 'en': 'Argentina'},
  'AM': {'ar': 'أرمينيا', 'en': 'Armenia'},
  'AU': {'ar': 'أستراليا', 'en': 'Australia'},
  'AT': {'ar': 'النمسا', 'en': 'Austria'},
  'AZ': {'ar': 'أذربيجان', 'en': 'Azerbaijan'},
  'BS': {'ar': 'جزر البهاما', 'en': 'Bahamas'},
  'BH': {'ar': 'البحرين', 'en': 'Bahrain'},
  'BD': {'ar': 'بنغلاديش', 'en': 'Bangladesh'},
  'BB': {'ar': 'بربادوس', 'en': 'Barbados'},
  'BY': {'ar': 'بيلاروسيا', 'en': 'Belarus'},
  'BE': {'ar': 'بلجيكا', 'en': 'Belgium'},
  'BZ': {'ar': 'بليز', 'en': 'Belize'},
  'BJ': {'ar': 'بنين', 'en': 'Benin'},
  'BT': {'ar': 'بوتان', 'en': 'Bhutan'},
  'BO': {'ar': 'بوليفيا', 'en': 'Bolivia'},
  'BA': {'ar': 'البوسنة والهرسك', 'en': 'Bosnia and Herzegovina'},
  'BW': {'ar': 'بوتسوانا', 'en': 'Botswana'},
  'BR': {'ar': 'البرازيل', 'en': 'Brazil'},
  'BN': {'ar': 'بروناي', 'en': 'Brunei'},
  'BG': {'ar': 'بلغاريا', 'en': 'Bulgaria'},
  'BF': {'ar': 'بوركينا فاسو', 'en': 'Burkina Faso'},
  'BI': {'ar': 'بوروندي', 'en': 'Burundi'},
  'KH': {'ar': 'كمبوديا', 'en': 'Cambodia'},
  'CM': {'ar': 'الكاميرون', 'en': 'Cameroon'},
  'CA': {'ar': 'كندا', 'en': 'Canada'},
  'CV': {'ar': 'الرأس الأخضر', 'en': 'Cape Verde'},
  'CF': {'ar': 'جمهورية أفريقيا الوسطى', 'en': 'Central African Republic'},
  'TD': {'ar': 'تشاد', 'en': 'Chad'},
  'CL': {'ar': 'تشيلي', 'en': 'Chile'},
  'CN': {'ar': 'الصين', 'en': 'China'},
  'CO': {'ar': 'كولومبيا', 'en': 'Colombia'},
  'KM': {'ar': 'جزر القمر', 'en': 'Comoros'},
  'CG': {'ar': 'الكونغو', 'en': 'Congo'},
  'CR': {'ar': 'كوستاريكا', 'en': 'Costa Rica'},
  'HR': {'ar': 'كرواتيا', 'en': 'Croatia'},
  'CU': {'ar': 'كوبا', 'en': 'Cuba'},
  'CY': {'ar': 'قبرص', 'en': 'Cyprus'},
  'CZ': {'ar': 'التشيك', 'en': 'Czech Republic'},
  'DK': {'ar': 'الدنمارك', 'en': 'Denmark'},
  'DJ': {'ar': 'جيبوتي', 'en': 'Djibouti'},
  'DM': {'ar': 'دومينيكا', 'en': 'Dominica'},
  'DO': {'ar': 'جمهورية الدومينيكان', 'en': 'Dominican Republic'},
  'EC': {'ar': 'الإكوادور', 'en': 'Ecuador'},
  'EG': {'ar': 'مصر', 'en': 'Egypt'},
  'SV': {'ar': 'السلفادور', 'en': 'El Salvador'},
  'GQ': {'ar': 'غينيا الاستوائية', 'en': 'Equatorial Guinea'},
  'ER': {'ar': 'إريتريا', 'en': 'Eritrea'},
  'EE': {'ar': 'إستونيا', 'en': 'Estonia'},
  'ET': {'ar': 'إثيوبيا', 'en': 'Ethiopia'},
  'FJ': {'ar': 'فيجي', 'en': 'Fiji'},
  'FI': {'ar': 'فنلندا', 'en': 'Finland'},
  'FR': {'ar': 'فرنسا', 'en': 'France'},
  'GA': {'ar': 'الغابون', 'en': 'Gabon'},
  'GM': {'ar': 'غامبيا', 'en': 'Gambia'},
  'GE': {'ar': 'جورجيا', 'en': 'Georgia'},
  'DE': {'ar': 'ألمانيا', 'en': 'Germany'},
  'GH': {'ar': 'غانا', 'en': 'Ghana'},
  'GR': {'ar': 'اليونان', 'en': 'Greece'},
  'GD': {'ar': 'غرينادا', 'en': 'Grenada'},
  'GT': {'ar': 'غواتيمالا', 'en': 'Guatemala'},
  'GN': {'ar': 'غينيا', 'en': 'Guinea'},
  'GW': {'ar': 'غينيا بيساو', 'en': 'Guinea-Bissau'},
  'GY': {'ar': 'غيانا', 'en': 'Guyana'},
  'HT': {'ar': 'هايتي', 'en': 'Haiti'},
  'HN': {'ar': 'هندوراس', 'en': 'Honduras'},
  'HU': {'ar': 'هنغاريا', 'en': 'Hungary'},
  'IS': {'ar': 'آيسلندا', 'en': 'Iceland'},
  'IN': {'ar': 'الهند', 'en': 'India'},
  'ID': {'ar': 'إندونيسيا', 'en': 'Indonesia'},
  'IR': {'ar': 'إيران', 'en': 'Iran'},
  'IQ': {'ar': 'العراق', 'en': 'Iraq'},
  'IE': {'ar': 'أيرلندا', 'en': 'Ireland'},
  'IL': {'ar': 'إسرائيل', 'en': 'Israel'},
  'IT': {'ar': 'إيطاليا', 'en': 'Italy'},
  'JM': {'ar': 'جامايكا', 'en': 'Jamaica'},
  'JP': {'ar': 'اليابان', 'en': 'Japan'},
  'JO': {'ar': 'الأردن', 'en': 'Jordan'},
  'KZ': {'ar': 'كازاخستان', 'en': 'Kazakhstan'},
  'KE': {'ar': 'كينيا', 'en': 'Kenya'},
  'KI': {'ar': 'كيريباتي', 'en': 'Kiribati'},
  'KP': {'ar': 'كوريا الشمالية', 'en': 'North Korea'},
  'KR': {'ar': 'كوريا الجنوبية', 'en': 'South Korea'},
  'KW': {'ar': 'الكويت', 'en': 'Kuwait'},
  'KG': {'ar': 'قيرغيزستان', 'en': 'Kyrgyzstan'},
  'LA': {'ar': 'لاوس', 'en': 'Laos'},
  'LV': {'ar': 'لاتفيا', 'en': 'Latvia'},
  'LB': {'ar': 'لبنان', 'en': 'Lebanon'},
  'LS': {'ar': 'ليسوتو', 'en': 'Lesotho'},
  'LR': {'ar': 'ليبيريا', 'en': 'Liberia'},
  'LY': {'ar': 'ليبيا', 'en': 'Libya'},
  'LI': {'ar': 'ليختنشتاين', 'en': 'Liechtenstein'},
  'LT': {'ar': 'ليتوانيا', 'en': 'Lithuania'},
  'LU': {'ar': 'لوكسمبورغ', 'en': 'Luxembourg'},
  'MG': {'ar': 'مدغشقر', 'en': 'Madagascar'},
  'MW': {'ar': 'مالاوي', 'en': 'Malawi'},
  'MY': {'ar': 'ماليزيا', 'en': 'Malaysia'},
  'MV': {'ar': 'المالديف', 'en': 'Maldives'},
  'ML': {'ar': 'مالي', 'en': 'Mali'},
  'MT': {'ar': 'مالطا', 'en': 'Malta'},
  'MH': {'ar': 'جزر مارشال', 'en': 'Marshall Islands'},
  'MR': {'ar': 'موريتانيا', 'en': 'Mauritania'},
  'MU': {'ar': 'موريشيوس', 'en': 'Mauritius'},
  'MX': {'ar': 'المكسيك', 'en': 'Mexico'},
  'FM': {'ar': 'ميكرونيزيا', 'en': 'Micronesia'},
  'MD': {'ar': 'مولدوفا', 'en': 'Moldova'},
  'MC': {'ar': 'موناكو', 'en': 'Monaco'},
  'MN': {'ar': 'منغوليا', 'en': 'Mongolia'},
  'ME': {'ar': 'الجبل الأسود', 'en': 'Montenegro'},
  'MA': {'ar': 'المغرب', 'en': 'Morocco'},
  'MZ': {'ar': 'موزمبيق', 'en': 'Mozambique'},
  'MM': {'ar': 'ميانمار', 'en': 'Myanmar'},
  'NA': {'ar': 'ناميبيا', 'en': 'Namibia'},
  'NR': {'ar': 'ناورو', 'en': 'Nauru'},
  'NP': {'ar': 'نيبال', 'en': 'Nepal'},
  'NL': {'ar': 'هولندا', 'en': 'Netherlands'},
  'NZ': {'ar': 'نيوزيلندا', 'en': 'New Zealand'},
  'NI': {'ar': 'نيكاراغوا', 'en': 'Nicaragua'},
  'NE': {'ar': 'النيجر', 'en': 'Niger'},
  'NG': {'ar': 'نيجيريا', 'en': 'Nigeria'},
  'MK': {'ar': 'مقدونيا الشمالية', 'en': 'North Macedonia'},
  'NO': {'ar': 'النرويج', 'en': 'Norway'},
  'OM': {'ar': 'عمان', 'en': 'Oman'},
  'PK': {'ar': 'باكستان', 'en': 'Pakistan'},
  'PW': {'ar': 'بالاو', 'en': 'Palau'},
  'PA': {'ar': 'بنما', 'en': 'Panama'},
  'PG': {'ar': 'بابوا غينيا الجديدة', 'en': 'Papua New Guinea'},
  'PY': {'ar': 'باراغواي', 'en': 'Paraguay'},
  'PE': {'ar': 'بيرو', 'en': 'Peru'},
  'PH': {'ar': 'الفلبين', 'en': 'Philippines'},
  'PL': {'ar': 'بولندا', 'en': 'Poland'},
  'PT': {'ar': 'البرتغال', 'en': 'Portugal'},
  'QA': {'ar': 'قطر', 'en': 'Qatar'},
  'RO': {'ar': 'رومانيا', 'en': 'Romania'},
  'RU': {'ar': 'روسيا', 'en': 'Russia'},
  'RW': {'ar': 'رواندا', 'en': 'Rwanda'},
  'KN': {'ar': 'سانت كيتس ونيفيس', 'en': 'Saint Kitts and Nevis'},
  'LC': {'ar': 'سانت لوسيا', 'en': 'Saint Lucia'},
  'VC': {
    'ar': 'سانت فنسنت وجزر غرينادين',
    'en': 'Saint Vincent and the Grenadines'
  },
  'WS': {'ar': 'ساموا', 'en': 'Samoa'},
  'SM': {'ar': 'سان مارينو', 'en': 'San Marino'},
  'ST': {'ar': 'ساو تومي وبرينسيب', 'en': 'Sao Tome and Principe'},
  'SA': {'ar': 'المملكة العربية السعودية', 'en': 'Saudi Arabia'},
  'SN': {'ar': 'السنغال', 'en': 'Senegal'},
  'RS': {'ar': 'صربيا', 'en': 'Serbia'},
  'SC': {'ar': 'سيشل', 'en': 'Seychelles'},
  'SL': {'ar': 'سيراليون', 'en': 'Sierra Leone'},
  'SG': {'ar': 'سنغافورة', 'en': 'Singapore'},
  'SK': {'ar': 'سلوفاكيا', 'en': 'Slovakia'},
  'SI': {'ar': 'سلوفينيا', 'en': 'Slovenia'},
  'SB': {'ar': 'جزر سليمان', 'en': 'Solomon Islands'},
  'SO': {'ar': 'الصومال', 'en': 'Somalia'},
  'ZA': {'ar': 'جنوب أفريقيا', 'en': 'South Africa'},
  'SS': {'ar': 'جنوب السودان', 'en': 'South Sudan'},
  'ES': {'ar': 'إسبانيا', 'en': 'Spain'},
  'LK': {'ar': 'سريلانكا', 'en': 'Sri Lanka'},
  'SD': {'ar': 'السودان', 'en': 'Sudan'},
  'SR': {'ar': 'سورينام', 'en': 'Suriname'},
  'SE': {'ar': 'السويد', 'en': 'Sweden'},
  'CH': {'ar': 'سويسرا', 'en': 'Switzerland'},
  'SY': {'ar': 'سوريا', 'en': 'Syria'},
  'TW': {'ar': 'تايوان', 'en': 'Taiwan'},
  'TJ': {'ar': 'طاجيكستان', 'en': 'Tajikistan'},
  'TZ': {'ar': 'تنزانيا', 'en': 'Tanzania'},
  'TH': {'ar': 'تايلاند', 'en': 'Thailand'},
  'TL': {'ar': 'تيمور الشرقية', 'en': 'Timor-Leste'},
  'TG': {'ar': 'توغو', 'en': 'Togo'},
  'TO': {'ar': 'تونغا', 'en': 'Tonga'},
  'TT': {'ar': 'ترينيداد وتوباغو', 'en': 'Trinidad and Tobago'},
  'TN': {'ar': 'تونس', 'en': 'Tunisia'},
  'TR': {'ar': 'تركيا', 'en': 'Turkey'},
  'TM': {'ar': 'تركمانستان', 'en': 'Turkmenistan'},
  'TV': {'ar': 'توفالو', 'en': 'Tuvalu'},
  'UG': {'ar': 'أوغندا', 'en': 'Uganda'},
  'UA': {'ar': 'أوكرانيا', 'en': 'Ukraine'},
  'AE': {'ar': 'الإمارات العربية المتحدة', 'en': 'United Arab Emirates'},
  'GB': {'ar': 'المملكة المتحدة', 'en': 'United Kingdom'},
  'US': {'ar': 'الولايات المتحدة الأمريكية', 'en': 'United States'},
  'UY': {'ar': 'أوروغواي', 'en': 'Uruguay'},
  'UZ': {'ar': 'أوزبكستان', 'en': 'Uzbekistan'},
  'VU': {'ar': 'فانواتو', 'en': 'Vanuatu'},
  'VA': {'ar': 'الفاتيكان', 'en': 'Vatican City'},
  'VE': {'ar': 'فنزويلا', 'en': 'Venezuela'},
  'VN': {'ar': 'فيتنام', 'en': 'Vietnam'},
  'YE': {'ar': 'اليمن', 'en': 'Yemen'},
  'ZM': {'ar': 'زامبيا', 'en': 'Zambia'},
  'ZW': {'ar': 'زيمبابوي', 'en': 'Zimbabwe'},
};
