abstract class LocalDataProvider {
  static List<Map<String, String>> get teamMembers => [
        {
          'name': 'Omar Nasr',
          'imagePath':
              'https://firebasestorage.googleapis.com/v0/b/fcis-da7f4.appspot.com/o/images%2Ffile.jpg?alt=media&token=7f050ff7-8d8d-4ea4-84da-3d254c36c0c2',
          'role': 'Flutter Developer',
          'contactUrl': 'https://linktr.ee/J3_Unknown'
        },
        {
          'name': 'Mahmoud Saad',
          'imagePath':
              'https://firebasestorage.googleapis.com/v0/b/fcis-da7f4.appspot.com/o/IMG_%D9%A2%D9%A0%D9%A2%D9%A4%D9%A1%D9%A0%D9%A2%D9%A9_%D9%A1%D9%A1%D9%A5%D9%A7%D9%A2%D9%A9%20(1).jpg?alt=media&token=33ea4477-f573-47e6-981e-c01dc81c1c8b',
          'role': 'Flutter Developer',
          'contactUrl': 'https://linktr.ee/malik1307'
        },
        {
          'name': 'Saif Elnawawy',
          'imagePath':
              'https://firebasestorage.googleapis.com/v0/b/fcis-da7f4.appspot.com/o/images%2F459111528_411397035091165_5639055007617670316_n.jpg?alt=media&token=6ee42433-ee9f-449c-bef2-3abf21edd5b6',
          'role': 'Flutter Developer',
          'contactUrl':
              'https://linktr.ee/Se_if?utm_source=linktree_profile_share'
        },
        {
          'name': 'Omar M. Hassan',
          'imagePath':
              'https://firebasestorage.googleapis.com/v0/b/fcis-da7f4.appspot.com/o/417357665_1165557908119538_5289593370887603831_n.jpg?alt=media&token=d112e3d8-3182-409a-a83e-0e8c581ccc4d',
          'role': 'Backend Developer',
          'contactUrl': 'https://0mr.me/who'
        },
        {
          'name': 'Ahmed M. Khalaf',
          'imagePath':
              'https://firebasestorage.googleapis.com/v0/b/fcis-da7f4.appspot.com/o/WhatsApp%20Image%202025-03-23%20at%2017.44.20_2ac6c493.jpg?alt=media&token=cd0c8dad-6c38-4153-9396-53c98c9bc30a',
          'role': 'UI/UX Designer',
          'contactUrl':
              'https://linktr.ee/ZVAXEROWS?utm_source=linktree_admin_share'
        },
        {
          'name': 'Mahmoud Ahmed',
          'imagePath':
              'https://firebasestorage.googleapis.com/v0/b/fcis-da7f4.appspot.com/o/images%2Ffile%20(4).jpg?alt=media&token=66fabec5-9958-4217-81cc-73bfe4cabdba',
          'role': 'UI/UX Designer',
          'contactUrl': 'https://linktr.ee/mahmoud588'
        },
        {
          'name': 'Ibrahim Abo Elso\'ud',
          'imagePath':
              'https://images-cdn.ubuy.co.in/64c7e79e11e2491d3f730794-flag-of-palestine-3x5-ft-flags-3-x-5.jpg',
          'role': 'Contributor',
          'contactUrl': 'http://Aboelsoud.vercel.app'
        },
      ];

  static List<String> semesters = [
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven ',
    'Eight',
  ];

  static String Level(String semester) {
    switch (semester) {
      case "One":
      case "Two":
        return "First Level";

      case "Three":
      case "Four":
        return "Second Level";

      case "Five":
      case "Six":
        return "Third Level";

      case "Seven":
      case "Eight":
        return "Fourth Level";

      default:
        return null.toString();
    }
  }
}
