import 'package:mockito/annotations.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/create_team/provider.dart';

// Generate mocks for core providers
@GenerateMocks([
  MainProvider,
  CreateTeamProvider,
])
void main() {}