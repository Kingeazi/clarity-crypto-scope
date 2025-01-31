import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types
} from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Ensure can register address for monitoring",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    const wallet1 = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall(
        "crypto-scope",
        "register-monitor",
        [types.principal(wallet1.address), types.uint(1000)],
        deployer.address
      )
    ]);
    
    assertEquals(block.receipts.length, 1);
    assertEquals(block.height, 2);
    
    block.receipts[0].result
      .expectOk()
      .expectBool(true);
  },
});

Clarinet.test({
  name: "Ensure only owner can register monitors",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet1 = accounts.get("wallet_1")!;
    const wallet2 = accounts.get("wallet_2")!;
    
    let block = chain.mineBlock([
      Tx.contractCall(
        "crypto-scope", 
        "register-monitor",
        [types.principal(wallet2.address), types.uint(1000)],
        wallet1.address
      )
    ]);
    
    assertEquals(block.receipts.length, 1);
    assertEquals(block.height, 2);
    
    block.receipts[0].result
      .expectErr()
      .expectUint(100);
  },
});

Clarinet.test({
  name: "Can add and retrieve alerts",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    const wallet1 = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall(
        "crypto-scope",
        "add-alert", 
        [types.principal(wallet1.address), types.ascii("TRANSFER")],
        deployer.address
      )
    ]);
    
    assertEquals(block.receipts.length, 1);
    block.receipts[0].result.expectOk();
    
    let alerts = chain.callReadOnlyFn(
      "crypto-scope",
      "get-alerts",
      [types.principal(wallet1.address)],
      deployer.address
    );
    
    alerts.result.expectOk();
  },
});
