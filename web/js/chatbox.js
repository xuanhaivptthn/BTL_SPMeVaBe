/* web/js/chatbox.js */

(function () {
    // 1. Configuration and state variables
    const STORAGE_KEY_HISTORY = "Antigravity_Chatbox_History";
    const STORAGE_KEY_OPEN = "Antigravity_Chatbox_IsOpen";
    
    // Default config (will be updated by JSON)
    let chatConfig = {
        welcomeMessage: "Xin chào! Tôi là trợ lý ảo hỗ trợ khách hàng. Bạn cần giúp đỡ điều gì?",
        defaultResponse: "Xin lỗi, tôi chưa hiểu câu hỏi của bạn. Vui lòng liên hệ Hotline 1900 1234 để gặp nhân viên hỗ trợ trực tiếp.",
        suggestions: [],
        qaPairs: []
    };

    let isChatOpen = false;
    let messages = [];

    // Helper: Get context path safely
    const contextPath = window.contextPath || "";

    // 2. Utility: Vietnamese Tone Normalization (removes accents for robust search)
    function removeVietnameseTones(str) {
        if (!str) return "";
        str = str.toLowerCase();
        str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, "a");
        str = str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, "e");
        str = str.replace(/ì|í|ị|ỉ|ĩ/g, "i");
        str = str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, "o");
        str = str.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, "u");
        str = str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g, "y");
        str = str.replace(/đ/g, "d");
        // Remove special punctuation but keep spaces
        str = str.replace(/[^\w\s]/gi, "");
        // Clean up double spaces
        str = str.replace(/\s+/g, " ");
        return str.trim();
    }

    // 3. Storage Utilities
    function saveHistory() {
        sessionStorage.setItem(STORAGE_KEY_HISTORY, JSON.stringify(messages));
    }

    function loadHistory() {
        const stored = sessionStorage.getItem(STORAGE_KEY_HISTORY);
        if (stored) {
            try {
                messages = JSON.parse(stored);
            } catch (e) {
                messages = [];
            }
        }
    }

    function saveOpenState() {
        sessionStorage.setItem(STORAGE_KEY_OPEN, isChatOpen ? "true" : "false");
    }

    function loadOpenState() {
        const stored = sessionStorage.getItem(STORAGE_KEY_OPEN);
        isChatOpen = (stored === "true");
    }

    // 4. Load JSON Database
    async function loadChatConfig() {
        try {
            const response = await fetch(`${contextPath}/data/chat-data.json`);
            if (response.ok) {
                chatConfig = await response.json();
            } else {
                console.error("Failed to load chat-data.json. Using fallback local responses.");
            }
        } catch (error) {
            console.error("Error loading chat configuration:", error);
        }
    }

    // 5. HTML Code Injection
    function injectChatboxHTML() {
        if (document.getElementById("chatbox-wrapper")) return;

        const wrapper = document.createElement("div");
        wrapper.id = "chatbox-wrapper";
        wrapper.innerHTML = `
            <!-- Floating Bubble Toggle Button -->
            <button class="chatbox-toggle" id="chatbox-toggle" aria-label="Hỗ trợ khách hàng">
                <i class="far fa-comment-dots" id="chatbox-toggle-icon"></i>
            </button>

            <!-- Chat Window -->
            <div class="chatbox-container" id="chatbox-container">
                <!-- Header -->
                <div class="chatbox-header">
                    <div class="chatbox-header-info">
                        <div class="chatbox-avatar">
                            <i class="fas fa-heartbeat"></i>
                        </div>
                        <div class="chatbox-title-wrapper">
                            <h3 class="chatbox-title">Mẹ & Bé Hỗ Trợ 24/7</h3>
                            <span class="chatbox-subtitle">
                                <span class="chatbox-status-dot"></span>
                                Trực tuyến
                            </span>
                        </div>
                    </div>
                    <button class="chatbox-close" id="chatbox-close" aria-label="Đóng chat">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <!-- Chat Body (Messages) -->
                <div class="chatbox-body" id="chatbox-body">
                    <div id="chat-messages-container" style="display:flex; flex-direction:column; gap:15px;"></div>
                    <!-- Typing Indicator -->
                    <div class="chat-msg bot" id="chat-typing-indicator" style="display: none; align-self: flex-start;">
                        <div class="chat-msg-bubble">
                            <div class="typing-indicator">
                                <div class="typing-dot"></div>
                                <div class="typing-dot"></div>
                                <div class="typing-dot"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Footer / Input Form -->
                <div class="chatbox-input-container">
                    <form class="chatbox-form" id="chatbox-form" autocomplete="off">
                        <input type="text" class="chatbox-input" id="chatbox-input" placeholder="Nhập câu hỏi của bạn..." />
                        <button type="submit" class="chatbox-send-btn" id="chatbox-send" aria-label="Gửi tin nhắn">
                            <i class="fas fa-paper-plane"></i>
                        </button>
                    </form>
                </div>
            </div>
        `;
        document.body.appendChild(wrapper);
    }

    // 6. DOM Rendering Methods
    function renderMessage(sender, text, timestamp) {
        const container = document.getElementById("chat-messages-container");
        if (!container) return;

        const time = timestamp || new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        
        const msgDiv = document.createElement("div");
        msgDiv.className = `chat-msg ${sender}`;
        
        msgDiv.innerHTML = `
            <div class="chat-msg-bubble">${text}</div>
            <div class="chat-msg-time">${time}</div>
        `;
        
        container.appendChild(msgDiv);
        scrollToBottom();
    }

    function renderSuggestions() {
        const container = document.getElementById("chat-messages-container");
        if (!container || !chatConfig.suggestions || chatConfig.suggestions.length === 0) return;

        // Remove old suggestions first if any exist
        const oldSugg = document.querySelector(".chat-suggestions");
        if (oldSugg) oldSugg.remove();

        const suggestionsDiv = document.createElement("div");
        suggestionsDiv.className = "chat-suggestions";
        
        chatConfig.suggestions.forEach(sugg => {
            const btn = document.createElement("button");
            btn.className = "chat-suggestion-btn";
            btn.innerHTML = sugg.text;
            btn.addEventListener("click", () => handleSuggestionClick(sugg));
            suggestionsDiv.appendChild(btn);
        });

        container.appendChild(suggestionsDiv);
        scrollToBottom();
    }

    function scrollToBottom() {
        const body = document.getElementById("chatbox-body");
        if (body) {
            body.scrollTop = body.scrollHeight;
        }
    }

    function showTypingIndicator() {
        const indicator = document.getElementById("chat-typing-indicator");
        if (indicator) {
            // Move typing indicator to the bottom of the container
            const container = document.getElementById("chat-messages-container");
            container.appendChild(indicator);
            indicator.style.display = "block";
            scrollToBottom();
        }
    }

    function hideTypingIndicator() {
        const indicator = document.getElementById("chat-typing-indicator");
        if (indicator) {
            indicator.style.display = "none";
        }
    }

    // 7. Core Match Logic (Smart Keyword Engine)
    function findBestResponse(userText) {
        const normalizedInput = removeVietnameseTones(userText);
        
        // Split user input into words for word-matching
        const inputWords = normalizedInput.split(/\s+/);
        
        let bestMatch = null;
        let highestMatchCount = 0;

        // Combine suggestions and qaPairs for search
        const allCandidates = [
            ...chatConfig.suggestions,
            ...chatConfig.qaPairs
        ];

        allCandidates.forEach(cand => {
            let matchCount = 0;
            
            // Check matching keywords
            cand.keywords.forEach(keyword => {
                const normalizedKeyword = removeVietnameseTones(keyword);
                
                // If it's a multi-word phrase, check if it's contained inside the input directly
                if (normalizedKeyword.includes(" ")) {
                    if (normalizedInput.includes(normalizedKeyword)) {
                        matchCount += 3; // Weight phrase matches higher!
                    }
                } else {
                    // Single word match
                    if (inputWords.includes(normalizedKeyword)) {
                        matchCount += 1;
                    } else if (normalizedInput.includes(normalizedKeyword)) {
                        matchCount += 0.5; // partial match
                    }
                }
            });

            if (matchCount > highestMatchCount) {
                highestMatchCount = matchCount;
                bestMatch = cand;
            }
        });

        // We require a minimum threshold of matching score
        if (bestMatch && highestMatchCount >= 0.5) {
            return bestMatch.response;
        }

        return chatConfig.defaultResponse;
    }

    // 8. Event Handlers
    function toggleChatbox() {
        const container = document.getElementById("chatbox-container");
        const toggleBtn = document.getElementById("chatbox-toggle");
        const toggleIcon = document.getElementById("chatbox-toggle-icon");
        
        isChatOpen = !isChatOpen;
        saveOpenState();

        if (isChatOpen) {
            container.classList.add("open");
            toggleBtn.classList.add("active");
            toggleIcon.className = "fas fa-times";
            
            // If empty history, boot greeting
            if (messages.length === 0) {
                sendBotGreeting();
            }
            scrollToBottom();
        } else {
            container.classList.remove("open");
            toggleBtn.classList.remove("active");
            toggleIcon.className = "far fa-comment-dots";
        }
    }

    function sendBotGreeting() {
        const time = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        renderMessage("bot", chatConfig.welcomeMessage, time);
        messages.push({ sender: "bot", text: chatConfig.welcomeMessage, timestamp: time });
        
        // Show suggestions
        renderSuggestions();
        saveHistory();
    }

    function handleSuggestionClick(suggestion) {
        // Remove suggestions from view so user can't click them repeatedly in the flow
        const oldSugg = document.querySelector(".chat-suggestions");
        if (oldSugg) oldSugg.remove();

        // Render user message
        const time = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        renderMessage("user", suggestion.text, time);
        messages.push({ sender: "user", text: suggestion.text, timestamp: time });
        saveHistory();

        // Trigger bot response
        triggerBotResponse(suggestion.response);
    }

    function handleFormSubmit(e) {
        e.preventDefault();
        const input = document.getElementById("chatbox-input");
        const text = input.value.trim();
        if (!text) return;

        input.value = "";

        // Remove old suggestions
        const oldSugg = document.querySelector(".chat-suggestions");
        if (oldSugg) oldSugg.remove();

        // Render user message
        const time = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        renderMessage("user", text, time);
        messages.push({ sender: "user", text: text, timestamp: time });
        saveHistory();

        // Find bot response
        const responseText = findBestResponse(text);

        // Trigger bot response
        triggerBotResponse(responseText);
    }

    function triggerBotResponse(responseText) {
        showTypingIndicator();

        // Simulated high-end delay (800ms - 1200ms based on length)
        const delay = Math.min(1200, Math.max(600, responseText.length * 6));

        setTimeout(() => {
            hideTypingIndicator();
            const time = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
            
            renderMessage("bot", responseText, time);
            messages.push({ sender: "bot", text: responseText, timestamp: time });
            
            // Re-render suggestions at the very end of the chat to keep driving user interaction
            renderSuggestions();
            
            saveHistory();
        }, delay);
    }

    // 9. Initial Setup & Event Listeners
    async function init() {
        // Step A: Load JSON data
        await loadChatConfig();

        // Step B: Inject Chat HTML
        injectChatboxHTML();

        // Step C: Restore states
        loadHistory();
        loadOpenState();

        const container = document.getElementById("chatbox-container");
        const toggleBtn = document.getElementById("chatbox-toggle");
        const toggleIcon = document.getElementById("chatbox-toggle-icon");
        const closeBtn = document.getElementById("chatbox-close");
        const form = document.getElementById("chatbox-form");

        // Set initial visual states
        if (isChatOpen) {
            container.classList.add("open");
            toggleBtn.classList.add("active");
            toggleIcon.className = "fas fa-times";
        }

        // Render historical messages
        if (messages.length > 0) {
            messages.forEach(msg => {
                renderMessage(msg.sender, msg.text, msg.timestamp);
            });
            // Show suggestions after history
            renderSuggestions();
        }

        // Step D: Attach Event Listeners
        toggleBtn.addEventListener("click", toggleChatbox);
        closeBtn.addEventListener("click", toggleChatbox);
        form.addEventListener("submit", handleFormSubmit);
    }

    // Run initialization on DOM load
    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }
})();
