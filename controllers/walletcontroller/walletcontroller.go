package walletcontroller

import (
	"net/http"
    "github.com/vitaliy-paliy/xumple/models"
    "github.com/vitaliy-paliy/xumple/database"
    "github.com/stellar/go/clients/horizonclient"
    "github.com/stellar/go/keypair"
    "github.com/stellar/go/network"
    "github.com/stellar/go/protocols/horizon"
    "github.com/stellar/go/txnbuild"
	"github.com/segmentio/ksuid"
)

func GetBalance(user *models.User) (*horizon.Balance, *models.Error) {
	if err := database.CheckUserInDatabase(user); err != nil {
		return nil, err
	}

    request := horizonclient.AccountRequest{AccountID: user.WalletAddress}
    account, err := horizonclient.DefaultTestNetClient.AccountDetail(request)
    if err != nil {
		return nil, &models.Error{Code: 500, Message: err.Error()}
    }

    return &account.Balances[0], nil
}

func FundWallet(user *models.User) *models.Error {
	_, err := http.Get("https://friendbot.stellar.org/?addr=" + user.WalletAddress)
	if err != nil {
		return &models.Error{Code: 500, Message: err.Error()}
	}
	transaction := &models.Transaction{Sender: user.Username+"'s bank", Recipient: user.ID, Amount: "10000", ID: ksuid.New().String()}
	database.Database.Create(transaction)

	return nil
}

func GetUserTransactions(user *models.User) (*[]models.Transaction, *models.Error) {
	if err := database.CheckUserInDatabase(user); err != nil {
		return nil, err
	}

	var transactions []models.Transaction
	database.Database.Where("sender = ?", user.ID).Or("recipient = ?", user.ID).Find(&transactions)

	return &transactions, nil
}

func SendMoney(transaction *models.Transaction) (*horizon.Transaction, *models.Error) {
	var sender, recipient models.User
	sender.ID = transaction.Sender
	recipient.ID = transaction.Recipient
	if err := database.CheckUserInDatabase(&sender); err != nil {
		return nil, err
	}

	if err := database.CheckUserInDatabase(&recipient); err != nil {
		return nil, err
	}

	resp, err := handleTransaction(&recipient, &sender, transaction)
	if err != nil {
		return nil, err
	}

	transaction.ID = resp.ID
	database.Database.Create(transaction)

    return resp, nil
}

func CashOut(transaction *models.Transaction) (*models.Error) {
	var sender, recipient models.User
	recipient.WalletAddress = "GCHBZD6IHXAM72NFIXMBXUAEFAWNIU7NSB4452IIY2U56Q5KUE75H2YV"
	sender.ID = transaction.Sender

	if err := database.CheckUserInDatabase(&sender); err != nil {
		return err
	}

	resp, err := handleTransaction(&recipient, &sender, transaction)
	if err != nil {
		return err
	}

	transaction.ID = resp.ID
	transaction.Recipient = sender.Username + "'s bank"
	database.Database.Create(transaction)

    return nil
}

func handleTransaction(recipient *models.User, sender *models.User, transaction *models.Transaction) (*horizon.Transaction, *models.Error) {
	client := horizonclient.DefaultTestNetClient

    destAccountRequest := horizonclient.AccountRequest{AccountID: recipient.WalletAddress}
    _, err := client.AccountDetail(destAccountRequest)
    if err != nil {
		return nil, &models.Error{Code: 400, Message: "Invalid destination account address"}
    }

    sourceID := keypair.MustParseFull(sender.WalletPrivateKey)
    sourceRequest := horizonclient.AccountRequest{AccountID: sourceID.Address()}
    sourceAccount, err := client.AccountDetail(sourceRequest)
    if err != nil {
		return nil, &models.Error{Code: 400, Message: "Invalid source account address"}
    }

    tx, err := txnbuild.NewTransaction(
	txnbuild.TransactionParams{
	    SourceAccount:        &sourceAccount,
	    IncrementSequenceNum: true,
	    BaseFee:              txnbuild.MinBaseFee,
	    Timebounds:           txnbuild.NewInfiniteTimeout(),
	    Operations: []txnbuild.Operation{
		&txnbuild.Payment{
		    Destination: recipient.WalletAddress,
		    Amount:      transaction.Amount,
		    Asset:       txnbuild.NativeAsset{},
		},
	    },
	},
    )

    if err != nil {
		return nil, &models.Error{Code: 500, Message: err.Error()}
    }

    tx, err = tx.Sign(network.TestNetworkPassphrase, sourceID)

    if err != nil {
		return nil, &models.Error{Code: 500, Message: err.Error()}
    }

    resp, err := horizonclient.DefaultTestNetClient.SubmitTransaction(tx)
    if err != nil {
		return nil, &models.Error{Code: 500, Message: "An Error occured. Check your balance and try again (Please account for $1.1 blockchain fee)"}
    }

	return &resp, nil
}
