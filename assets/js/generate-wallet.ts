import { generateWallet, GeneratedWallet, cryptoWaitReady } from '@autonomys/auto-utils';

export async function main(): Promise<GeneratedWallet> {
  console.log('\x1b[Generate random wallet...\x1b[0m');
  await cryptoWaitReady()
  const {
    mnemonic,
    keyringPair,
    address,
    commonAddress,
  } = generateWallet();
  console.log('\x1b[32mWallet generated successfully.\x1b[0m');

  console.log('address', address)
  console.log('mnemonic', mnemonic)
  
  return  {
    mnemonic,
    keyringPair,
    address,
    commonAddress,
  }
}

main();