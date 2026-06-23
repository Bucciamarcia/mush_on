import 'package:collection/collection.dart';
import 'package:mush_on/settings/stripe/stripe_models.dart';

StripeAccount? connectedAccountForMode(
  List<StripeAccount> accounts,
  StripeMode mode,
) {
  return accounts.firstWhereOrNull(
    (account) => account.mode == mode && !account.archived,
  );
}

List<StripeAccount> archivedAccountsForMode(
  List<StripeAccount> accounts,
  StripeMode mode,
) {
  return accounts
      .where((account) => account.mode == mode && account.archived)
      .toList();
}
