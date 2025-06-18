#!/usr/bin/env python3
"""
Synchronise NameSilo A‑record with the droplet IP produced by Terraform.
Requires: requests, xmltodict
"""
import argparse, requests, xmltodict, sys

def call(endpoint: str, params: dict):
    r = requests.get(f"https://www.namesilo.com/api/{endpoint}", params=params, timeout=15)
    r.raise_for_status()
    data = xmltodict.parse(r.text)
    if data["namesilo"]["reply"]["code"] != '300':
        raise RuntimeError(data["namesilo"]["reply"].get("detail", "Unknown API error"))
    return data

def main():
    p = argparse.ArgumentParser()
    p.add_argument("--api-key", required=True)
    p.add_argument("--domain", required=True)
    p.add_argument("--ip", required=True)
    args = p.parse_args()

    base = {"version": "1", "type": "xml", "key": args.api_key}
    existing = call("dnsListRecords", {**base, "domain": args.domain})

    records = existing["namesilo"]["reply"].get("resource_record", [])
    if isinstance(records, dict):  # Only one record present
        records = [records]

    a_records = [r for r in records if r["type"] == "A" and r["host"].rstrip('.') == args.domain]

    if a_records and a_records[0]["value"] == args.ip:
        print("✅ DNS already up‑to‑date")
        return

    if a_records:
        print("🔄 Removing stale A‑record…")
        call("dnsDeleteRecord", {**base, "domain": args.domain, "rrid": a_records[0]["record_id"]})

    print("➕ Adding new A‑record…")
    call("dnsAddRecord", {
        **base,
        "domain": args.domain,
        "rrtype": "A",
        "rrhost": "@",
        "rrvalue": args.ip,
        "rrttl": "3600",
    })
    print("✅ DNS updated →", args.ip)

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        sys.exit(f"❌ {e}")
