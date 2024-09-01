import { connectToPolkadot, sendRemark } from './sendTransaction';

async function main(): Promise<void> {
  const [senderSeed, hash] = process.argv.slice(2);
  
  if (!senderSeed || !hash) {
    console.error('Usage: node dist/sendRemark.js <senderSeed> <hash>');
    process.exit(1);
  }

  try {
    const api = await connectToPolkadot();
    const txHash = await sendRemark(api, senderSeed, hash);
    console.log(txHash);
    process.exit(0);
  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  }
}

main();