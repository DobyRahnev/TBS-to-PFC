function normedData = normalize(data)

normedData = reshape(data,[],1);
normedData = (normedData - mean(normedData))/std(normedData);