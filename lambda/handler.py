import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info("Received event: %s", json.dumps(event))
    
    # Extract finding details
    try:
        detail = event['detail']
        finding = detail['findings'][0]
        title = finding['Title']
        severity = finding['Severity']['Label']
        resource = finding['Resources'][0]['Id']
        
        # Simulate action
        action_taken = f"Tagged {resource} as '{severity}-Priority'"

        logger.info(f"Finding Title: {title}")
        logger.info(f"Severity: {severity}")
        logger.info(f"Resource: {resource}")
        logger.info(f"Action Taken: {action_taken}")
        
        return {
            "statusCode": 200,
            "body": json.dumps({
                "finding_id": finding['Id'],
                "severity": severity,
                "action_taken": action_taken
            })
        }
    
    except Exception as e:
        logger.error("Error processing event: %s", str(e))
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
