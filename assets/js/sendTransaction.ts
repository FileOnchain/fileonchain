import { activateWallet } from '@autonomys/auto-utils';
import { remark } from '@autonomys/auto-consensus';

export async function sendRemark(mnemonic: string, hash: string): Promise<string> {
  console.log('\x1b[32mActivating wallet...\x1b[0m');
  const { api, accounts: [sender]} = await activateWallet({ mnemonic});
  console.log('\x1b[32mWallet activated successfully.\x1b[0m');
  console.log('Sender address', sender.address)
  console.log('Hash', hash)

  const remarkTx = remark(api, hash, true);
  const txHash = await remarkTx.signAndSend(sender);
  
  return txHash.toHex();
}