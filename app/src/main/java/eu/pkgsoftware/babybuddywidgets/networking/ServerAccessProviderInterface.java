package eu.pkgsoftware.babybuddywidgets.networking;

import org.jetbrains.annotations.NotNull;

import java.util.Map;

public interface ServerAccessProviderInterface {
    @NotNull String getAppToken();
    @NotNull String getServerUrl();
    @NotNull Map<String, String> getAuthCookies();

    /**
     * Optional Cloudflare Zero Trust / Access headers.
     * If empty, clients should omit these headers.
     */
    @NotNull String getCfAccessClientId();
    @NotNull String getCfAccessClientSecret();
}
