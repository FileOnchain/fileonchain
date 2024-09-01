import { ApiPromise, WsProvider, Keyring } from '@polkadot/api';

export async function connectToPolkadot(): Promise<ApiPromise> {
  const wsProvider = new WsProvider('wss://rpc.polkadot.io');
  const api = await ApiPromise.create({ provider: wsProvider });
  return api;
}

export async function sendRemark(api: ApiPromise, senderSeed: string, hash: string): Promise<string> {
  const keyring = new Keyring({ type: 'sr25519' });
  const sender = keyring.addFromUri(senderSeed);

  const remark = api.tx.system.remark(hash);
  const txHash = await remark.signAndSend(sender);
  
  return txHash.toHex();
}