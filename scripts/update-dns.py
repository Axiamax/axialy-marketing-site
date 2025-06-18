#!/usr/bin/env python3
import argparse
import requests
import xmltodict

API_BASE = "https://www.namesilo.com/api"

def dns_list_records(api_key, domain):
    r = requests.get(f"{API_BASE}/dnsListRecords", params={
        "version": "1", "type": "xml", "key": api_key, "domain": domain
    })
    r.raise_for_status()
    recs = xmltodict.parse(r.text)["namesilo"]["reply"]["resource_record_list"]["resource_record"]
    return recs if isinstance(recs, list) else [recs]

def dns_update_record(api_key, domain, rrid, host, ip, ttl=7207):
    r = requests.get(f"{API_BASE}/dnsUpdateRecord", params={
        "version": "1", "type": "xml", "key": api_key,
        "domain": domain, "rrid": rrid, "rrhost": host,
        "rrvalue": ip, "rrttl": ttl
    })
    r.raise_for_status()
    return xmltodict.parse(r.text)

def main():
    p = argparse.ArgumentParser()
    p.add_argument("--api-key", required=True)
    p.add_argument("--domain", required=True)
    p.add_argument("--ip", required=True)
    args = p.parse_args()

    for rec in dns_list_records(args.api_key, args.domain):
        host = rec["host"]
        if host in ["@", "www"]:
            print(f"Updating {host}.{args.domain} → {args.ip}")
            dns_update_record(args.api_key, args.domain, rec["record_id"], host, args.ip)
    print("DNS update complete.")

if __name__ == "__main__":
    main()
