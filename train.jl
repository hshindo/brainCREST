workspace()
using Merlin
using ProgressMeter

function train()
    pers, feats, twis = readdata()
    train_pers, train_feats, train_twis = pers[1:166], feats[1:166], twis[1:166]
    test_pers, test_feats, test_twis = pers[167:184], feats[167:184], twis[167:184]
    nn = setup_model()
    opt = SGD(0.1)
    for epoch = 1:1000
        epoch % 100 == 1 && println("epoch: $epoch")
        train_loss = 0.0

        #progress = Progress(length(train_pers))
        for i = randperm(length(train_pers))
            per, feat, twi = train_pers[i], train_feats[i], train_twis[i]
            per = reshape(per, length(per), 1)
            feat = reshape(feat, length(feat), 1)
            y = Var(per)
            z = nn(Var(feat))
            out = mse_na(z, y)
            train_loss += sum(out.data)
            minimize!(opt, out)
            #next!(progress)
        end
        train_loss = round(train_loss/length(train_pers), 5)
        epoch % 100 == 1 && println("train_loss: $train_loss")

        # test
        test_loss = 0.0
        for (per,feat,twi) in zip(test_pers,test_feats,test_twis)
            per = reshape(per, length(per), 1)
            feat = reshape(feat, length(feat), 1)
            y = Var(per)
            z = nn(Var(feat))
            out = mse_na(z, y)
            test_loss += sum(out.data)
        end
        test_loss = round(test_loss/length(test_pers), 5)
        epoch % 100 == 1 && println("test_loss: $test_loss")
        epoch % 100 == 1 && println("")
    end
    println("finish")
end

include("data.jl")
include("model.jl")

persons = train()
