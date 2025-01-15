import subprocess
import os
import re

def get_fully_qualified_host(host_subdomain):
    result = subprocess.run(
        [
            'aws', 'rds', 'describe-db-instances',
            '--db-instance-identifier', host_subdomain,
            '--query', 'DBInstances[0].Endpoint.Address',
            '--output', 'text'
        ],
        capture_output=True, text=True, check=True,
    )
    return result.stdout.strip()

def generate_new_password(fully_qualified_host, port, user, profile):
    result = subprocess.run(
        [
            'aws', 'rds', 'generate-db-auth-token',
            '--hostname', fully_qualified_host,
            '--port', port,
            '--username', user,
            '--region', 'us-east-1',
            '--profile', profile,
        ],
        capture_output=True, text=True, check=True,
    )
    # The returned password will contain lots of colons that need to be escaped
    return result.stdout.strip().replace(':', '\\:')

def main():
    default_profile = 'devprod'
    skip_host = [
        # Comment out the hosts that have been moved to federated login
        "*",
        "db.aledade.com",
        "db-dev.aledade.com",
        "db-prod-read.aledade.com",
        "db-ergometer.aledade.com",
        # "db-ergometer-dev.aledade.com",
        "db-ranking-dev.aledade.com",
    ]
    pgpass_path = os.path.expanduser('~/.pgpass')
    new_lines = []
    try:
        with open(pgpass_path, 'r') as file:
            for raw_line in file:
                line = raw_line.strip()
                if not line:
                    continue

                # Split the line on colons, but ignore any that are escaped with `\`
                parts = re.split(r'(?<!\\):', line)
                if len(parts) != 5:
                    print(f"Skipping malformed line: {line}")
                    new_lines.append(raw_line)
                    continue

                host, port, db, user, _old_password = parts
                host_subdomain = host.split('.')[0]
                if host in skip_host:
                    print(f"Skipping {host}:{port}:{db}")
                    new_lines.append(raw_line)
                    continue

                print(f"Rotating password for {host}:{port}:{db}")
                fully_qualified_host = get_fully_qualified_host(host_subdomain)
                print(f"\tGenerating new password for {user}@{fully_qualified_host}:{port}")
                password = generate_new_password(fully_qualified_host, port, user, default_profile)
                new_lines.append(f"{host}:{port}:{db}:{user}:{password}\n")

        with open(pgpass_path, 'w') as file:
            file.writelines(new_lines)

    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()