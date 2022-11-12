import { Injectable } from '@nestjs/common';
import { SystemInfoResponse } from './system-info-response.dto';
import * as os from "os";
import axios from "axios";

@Injectable()
export class SystemService {
    private ExternalIpServiceUrl: string = "icanhazip.com";

    /**
     * Gets info about the current system and host
     * @returns Information about the current system
     */
    async getSystemInfo(): Promise<SystemInfoResponse> {
        var ip = await this.getExternalIp();

        const info = {
            version: process.env.APP_VERSION,
            build: process.env.BUILD_NUMBER,
            nodeVersion: process.version,
            hostName: os.hostname(),
            externalIp: ip
        };
        
        return info;
    }

    /**
     * Gets the external IP address of the system
     * @returns The external IP address of the system
     */
    async getExternalIp(): Promise<string> {
        const response = await axios.get(`https://${this.ExternalIpServiceUrl}`);
        return response.data.trim();
    }
}
