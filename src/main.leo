// The 'aleo_multisig_v2' program.
import credits.aleo;

program aleo_multisig_v3.aleo {
    const MAX_OWNERS:u8 = 8u8;
    const ZERO_ADDRESS:address = aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc;

    record Wallet {
        owner: address,
        wallet_address: address,
        owners: [address; 8],
        threshold: u8,
    }

    record TransferSigner {
        owner: address,
        wallet_address: address,
        transfer_id: field,
    }

    struct Transfer {
        to: address, // hash_to_field(hash_to_field(to) + transfer_id): obfuscated address, not the actual address
        amount: u64,
        confirmations: u8,
    }

    // hash_to_field(wallet_address) => u64;
    mapping balances: field => u64;
    // hash_to_field(hash_to_field(wallet_address) + transfer_id) => Transfer;
    mapping transfers: field => Transfer;

    // // if actual owners is less then MAX_OWNERS, then the rest of the owners are set to ZERO_ADDRESS
    async transition create_wallet(wallet_address: address, owners: [address; 8], threshold: u8) -> (Wallet, Wallet, Wallet, Wallet, Wallet, Wallet, Wallet, Wallet, Future) {
        assert_eq(threshold <= MAX_OWNERS && threshold >= 1u8, true);
        
        let wallet_record_1: Wallet = Wallet {
            owner: owners[0u8],
            wallet_address: wallet_address,
            owners: owners,
            threshold: threshold,
        };

        let wallet_record_2: Wallet = Wallet {
            owner: owners[1u8],
            wallet_address: wallet_address,
            owners: owners,
            threshold: threshold,
        };

        let wallet_record_3: Wallet = Wallet {
            owner: owners[2u8],
            wallet_address: wallet_address,
            owners: owners,
            threshold: threshold,
        };

        let wallet_record_4: Wallet = Wallet {
            owner: owners[3u8],
            wallet_address: wallet_address,
            owners: owners,
            threshold: threshold,
        };

        let wallet_record_5: Wallet = Wallet {
            owner: owners[4u8],
            wallet_address: wallet_address,
            owners: owners,
            threshold: threshold,
        };

        let wallet_record_6: Wallet = Wallet {
            owner: owners[5u8],
            wallet_address: wallet_address,
            owners: owners,
            threshold: threshold,
        };

        let wallet_record_7: Wallet = Wallet {
            owner: owners[6u8],
            wallet_address: wallet_address,
            owners: owners,
            threshold: threshold,
        };

        let wallet_record_8: Wallet = Wallet {
            owner: owners[7u8],
            wallet_address: wallet_address,
            owners: owners,
            threshold: threshold,
        };

        let wallet_address_hashed_to_field: field = BHP256::hash_to_field(wallet_address);
        return (wallet_record_1, wallet_record_2, wallet_record_3, wallet_record_4, wallet_record_5, wallet_record_6, wallet_record_7, wallet_record_8, finalize_create_wallet(wallet_address_hashed_to_field));
    }

    async function finalize_create_wallet(wallet_address_hashed_to_field: field) {
        assert_eq(Mapping::contains(balances, wallet_address_hashed_to_field), false);
        Mapping::set(balances, wallet_address_hashed_to_field, 0u64);
    }

    // use this function with caution, it will reveal who deposited the funds
    async transition deposit_public(wallet_address: address, amount: u64) -> Future {
        let wallet_address_hashed_to_field: field = BHP256::hash_to_field(wallet_address);
        return finalize_deposit_public(wallet_address_hashed_to_field, amount, credits.aleo/transfer_public_as_signer(self.address, amount));
    }

    async function finalize_deposit_public(wallet_address_hashed_to_field: field, amount: u64, transfer_function: Future) {
        assert_eq(Mapping::contains(balances, wallet_address_hashed_to_field), true);
        let current_balance: u64 = Mapping::get(balances, wallet_address_hashed_to_field);
        let new_balance: u64 = current_balance + amount;
        Mapping::set(balances, wallet_address_hashed_to_field, new_balance);
        transfer_function.await();
    }

    async transition deposit_private(wallet_address: address, amount: u64, credits: credits.aleo/credits) -> (credits.aleo/credits, Future) {
        let wallet_address_hashed_to_field: field = BHP256::hash_to_field(wallet_address);
        let (remaining_credits, transfer_function): (credits.aleo/credits, Future) = credits.aleo/transfer_private_to_public(credits, self.address, amount);
        return (remaining_credits, finalize_deposit_private(wallet_address_hashed_to_field, amount, transfer_function));
    }

    async function finalize_deposit_private(wallet_address_hashed_to_field: field, amount: u64, transfer_function: Future) {
        assert_eq(Mapping::contains(balances, wallet_address_hashed_to_field), true);
        let current_balance: u64 = Mapping::get(balances, wallet_address_hashed_to_field);
        let new_balance: u64 = current_balance + amount;
        Mapping::set(balances, wallet_address_hashed_to_field, new_balance);
        transfer_function.await();
    }

    async transition create_transfer(wallet: Wallet, to: address, amount: u64, transfer_id: field) -> (Wallet, TransferSigner, TransferSigner, TransferSigner, TransferSigner, TransferSigner, TransferSigner, TransferSigner, TransferSigner, Future) {
        let transfer_signer_1: TransferSigner = TransferSigner {
            owner: wallet.owners[0u8],
            wallet_address: wallet.wallet_address,
            transfer_id: transfer_id,
        };

        let transfer_signer_2: TransferSigner = TransferSigner {
            owner: wallet.owners[1u8],
            wallet_address: wallet.wallet_address,
            transfer_id: transfer_id,
        };

        let transfer_signer_3: TransferSigner = TransferSigner {
            owner: wallet.owners[2u8],
            wallet_address: wallet.wallet_address,
            transfer_id: transfer_id,
        };

        let transfer_signer_4: TransferSigner = TransferSigner {
            owner: wallet.owners[3u8],
            wallet_address: wallet.wallet_address,
            transfer_id: transfer_id,
        };

        let transfer_signer_5: TransferSigner = TransferSigner {
            owner: wallet.owners[4u8],
            wallet_address: wallet.wallet_address,
            transfer_id: transfer_id,
        };

        let transfer_signer_6: TransferSigner = TransferSigner {
            owner: wallet.owners[5u8],
            wallet_address: wallet.wallet_address,
            transfer_id: transfer_id,
        };

        let transfer_signer_7: TransferSigner = TransferSigner {
            owner: wallet.owners[6u8],
            wallet_address: wallet.wallet_address,
            transfer_id: transfer_id,
        };

        let transfer_signer_8: TransferSigner = TransferSigner {
            owner: wallet.owners[7u8],
            wallet_address: wallet.wallet_address,
            transfer_id: transfer_id,
        };

        let transfer_id_hashed_to_field: field = BHP256::hash_to_field(transfer_id);

        // to prevent non-owners call execute_transfer: we need to link the transfer to the wallet by hashing the wallet_address and the transfer_id together and use it as a key in the transfers mapping
        let wallet_address_hashed_to_field: field = BHP256::hash_to_field(wallet.wallet_address);
        let mapping_transfers_key: field = BHP256::hash_to_field(wallet_address_hashed_to_field + transfer_id_hashed_to_field);

        // obfuscate the to address by hashing it with the transfer_id
        let to_address_hashed_to_field: field = BHP256::hash_to_field(to);
        let to_address_obfuscated: address = BHP256::hash_to_address(to_address_hashed_to_field + transfer_id_hashed_to_field);

        return (wallet, transfer_signer_1, transfer_signer_2, transfer_signer_3, transfer_signer_4, transfer_signer_5, transfer_signer_6, transfer_signer_7, transfer_signer_8, finalize_create_transfer(wallet_address_hashed_to_field, mapping_transfers_key, to_address_obfuscated, amount));
    }

    async function finalize_create_transfer(wallet_address_hashed_to_field: field, mapping_transfers_key: field, to_address_obfuscated: address, amount: u64) {
        let current_balance: u64 = Mapping::get(balances, wallet_address_hashed_to_field);
        assert_eq(current_balance >= amount, true);
        assert_eq(Mapping::contains(transfers, mapping_transfers_key), false);

        let transfer: Transfer = Transfer {
            to: to_address_obfuscated,
            amount: amount,
            confirmations: 0u8,
        };
        Mapping::set(transfers, mapping_transfers_key, transfer);
    }
    

    async transition confirm_transfer(transfer_signer: TransferSigner) -> Future {
        let wallet_address_hashed_to_field: field = BHP256::hash_to_field(transfer_signer.wallet_address);
        let mapping_transfers_key: field = BHP256::hash_to_field(wallet_address_hashed_to_field + BHP256::hash_to_field(transfer_signer.transfer_id));
        return finalize_confirm_transfer(mapping_transfers_key);
    }

    async function finalize_confirm_transfer(mapping_transfers_key: field) {
        let transfer: Transfer = Mapping::get(transfers, mapping_transfers_key);
        Mapping::set(transfers, mapping_transfers_key, Transfer {
            to: transfer.to,
            amount: transfer.amount,
            confirmations: transfer.confirmations + 1u8,
        });
    }

    async transition execute_transfer(wallet: Wallet, transfer: Transfer, to: address, transfer_id: field) -> (credits.aleo/credits, Wallet, Future) {
        // we will check if the transfer is legit later in finalize_execute_transfer
        assert_eq(transfer.confirmations >= wallet.threshold, true);
        let wallet_address_hashed_to_field: field = BHP256::hash_to_field(wallet.wallet_address);
        let mapping_transfers_key: field = BHP256::hash_to_field(wallet_address_hashed_to_field + BHP256::hash_to_field(transfer_id));

        let (receiver_credits, transfer_function): (credits.aleo/credits, Future) = credits.aleo/transfer_public_to_private(to, transfer.amount);
        return (receiver_credits, wallet, finalize_execute_transfer(wallet_address_hashed_to_field, mapping_transfers_key, transfer, transfer_function));
    }

    async function finalize_execute_transfer(wallet_address_hashed_to_field: field, mapping_transfers_key: field, transfer: Transfer, transfer_function: Future) {
        // make sure offchain transfer is the same as onchain transfer
        let onchain_transfer: Transfer = Mapping::get(transfers, mapping_transfers_key);
        assert_eq(transfer, onchain_transfer);

        // check if the wallet has enough balance
        let current_balance: u64 = Mapping::get(balances, wallet_address_hashed_to_field);
        assert_eq(current_balance >= transfer.amount, true);

        // set the new balance
        let new_balance: u64 = current_balance - transfer.amount;
        Mapping::set(balances, wallet_address_hashed_to_field, new_balance);

        Mapping::remove(transfers, mapping_transfers_key);
        transfer_function.await();
    }
}
