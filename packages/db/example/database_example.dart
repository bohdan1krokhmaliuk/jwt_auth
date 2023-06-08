import 'package:db/db.dart';

Future<void> main() async {
  final client = PrismaClient();
  final maybeUser = await client.user.findUnique(
    where: UserWhereUniqueInput(id: 1),
  );

  if (maybeUser case final user?) {
    print(user.toJson());
  } else {
    print('User missing');
  }
}
