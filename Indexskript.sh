buckets=("originalimageproject" "formatedimageproject")
for bucket in ${buckets[@]}; do
	aws s3 rb s3://$bucket --force
	
	aws s3 mb s3://$bucket

	aws s3api put-public-access-block --bucket $bucket --public-access-block-configuration "BlockPublicPolicy=false"

	aws s3api put-bucket-ownership-controls --bucket $bucket --ownership-controls="Rules=[{ObjectOwnership=BucketOwnerPreferred}]"
done


